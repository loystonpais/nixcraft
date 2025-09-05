import os
import json
import urllib.request
import hashlib
import logging
from pathlib import Path
from time import sleep
from functools import cache
from dataclasses import dataclass
import re


SEMVER_PATTERN = re.compile(r"^\d+\.\d+\.\d+$")

SOURCES_DIR = Path("sources")
FETCH_DELAY = 0.1  # seconds
LOG_LEVEL = logging.INFO

logging.basicConfig(level=LOG_LEVEL, format="%(levelname)s: %(message)s")


def bytes_to_sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_json(path: Path) -> dict:
    if path.exists():
        with path.open() as f:
            return json.load(f)
    return {}


def save_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w") as f:
        json.dump(data, f, indent=2)


@cache
def fetch_json(url: str):
    sleep(FETCH_DELAY)
    with urllib.request.urlopen(url) as r:
        return json.load(r)


@cache
def fetch_file(url: str) -> bytes:
    sleep(FETCH_DELAY)
    with urllib.request.urlopen(url) as r:
        return r.read()


@dataclass(frozen=True)
class MavenDep:
    dep: str
    url: str

    @property
    def group(self) -> str:
        return self.dep.split(":")[0]

    @property
    def name(self) -> str:
        return self.dep.split(":")[1]

    @property
    def version(self) -> str:
        return self.dep.split(":")[2]

    @property
    def path(self) -> str:
        return self.group.replace(".", "/")

    def download_url(self, ext: str = "jar") -> str:
        return f"{self.url}/{self.path}/{self.name}/{self.version}/{self.name}-{self.version}.{ext}"

    def download_url_sha256(self) -> str:
        return self.download_url(ext="jar.sha256")

    def download_url_dep_json(self) -> str:
        return self.download_url(ext="json")


class QuiltMavenDep(MavenDep):
    def __init__(self, dep: str):
        super().__init__(dep=dep, url="https://maven.quiltmc.org/repository/release")


class FabricMavenDep(MavenDep):
    def __init__(self, dep: str):
        super().__init__(dep=dep, url="https://maven.fabricmc.net")




def update_loaders(
    meta_url: str,
    lockfile: Path,
    dep_class,
):
    lock_data = load_json(lockfile)

    logging.info(f"Fetching loaders from {meta_url}..")
    loaders = fetch_json(meta_url)

    for loader in loaders:
        version = loader.get("version")

        # Only allow versions strictly in x.y.z format
        if not version or not SEMVER_PATTERN.match(version):
            continue

        try:
            loader_dep = dep_class(loader["maven"])
            logging.info(f"Processing {dep_class.__name__} version {version}")

            loaderdepsjson = fetch_json(loader_dep.download_url_dep_json())
            libraries = loaderdepsjson["libraries"]

            def clean_libs(libs):
                return [lib["name"] for lib in libs]

            lock_data[version] = {
                "dependencies": {
                    "client": clean_libs(libraries["client"]),
                    "common": clean_libs(libraries["common"]),
                    "server": clean_libs(libraries["server"]),
                },
                "mainClass": loaderdepsjson["mainClass"],
            }

            all_libraries = (
                libraries["client"] + libraries["common"] + libraries["server"]
            )

            all_maven_objs = [
                MavenDep(dep=lib["name"], url=lib["url"]) for lib in all_libraries
            ] + [loader_dep]

            for maven_obj in all_maven_objs:
                if maven_obj.dep not in maven_libraries:
                    try:
                        sha256 = fetch_file(maven_obj.download_url_sha256()).decode()
                    except Exception:
                        sha256 = bytes_to_sha256_hex(
                            fetch_file(maven_obj.download_url())
                        )
                    maven_libraries[maven_obj.dep] = {
                        "url": maven_obj.url,
                        "sha256": sha256,
                    }

        except Exception as e:
            logging.error(f"Failed on version {version}: {e}")

    save_json(lockfile, lock_data)

maven_libraries = load_json(SOURCES_DIR / "maven-libraries.json")

if __name__ == "__main__":
    try:
        update_loaders(
            meta_url="https://meta.quiltmc.org/v3/versions/loader",
            lockfile=SOURCES_DIR / "quilt/lock.json",
            dep_class=QuiltMavenDep,
        )
        update_loaders(
            meta_url="https://meta.fabricmc.net/v2/versions/loader",
            lockfile=SOURCES_DIR / "fabric/lock.json",
            dep_class=FabricMavenDep,
        )
    finally:
        save_json(SOURCES_DIR / "maven-libraries.json", maven_libraries)
