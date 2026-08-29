import json
import logging
from pathlib import Path
from typing import Any, Dict, List, Optional
import requests
from requests.adapters import HTTPAdapter, Retry

API_BASE = "https://api.modrinth.com/v2"
TIMEOUT = 10
RETRIES = 5
USER_AGENT = "nixcraft (https://github.com/loystonpais/nixcraft)"

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")


def make_session() -> requests.Session:
    session = requests.Session()
    retries = Retry(
        total=RETRIES,
        backoff_factor=1,
        status_forcelist=[429, 500, 502, 503, 504],
    )
    adapter = HTTPAdapter(max_retries=retries)
    session.mount("https://", adapter)
    session.mount("http://", adapter)
    session.headers.update({"User-Agent": USER_AGENT})
    return session


def fetch_project_versions(
    session: requests.Session,
    project: str,
    game_versions: Optional[List[str]] = None,
    loaders: Optional[List[str]] = None,
) -> List[Dict[str, Any]]:
    params: Dict[str, str] = {}
    if game_versions:
        params["game_versions"] = json.dumps(game_versions)
    if loaders:
        params["loaders"] = json.dumps(loaders)

    url = f"{API_BASE}/project/{project}/version"
    resp = session.get(url, params=params, timeout=TIMEOUT)
    resp.raise_for_status()
    return resp.json()


def select_file(files: List[Dict[str, Any]]) -> Dict[str, Any]:
    if not files:
        raise ValueError("No files found in version")
    for file_info in files:
        if file_info.get("primary"):
            return file_info
    return files[0]


def update_modrinth_sources(
    projects_file: Path,
    lock_file: Path,
    session: requests.Session,
) -> None:
    if not projects_file.exists():
        logging.error(f"Projects file not found at {projects_file}")
        return

    with projects_file.open("r") as f:
        projects_config: Dict[str, Any] = json.load(f)

    lock_data: Dict[str, Any] = {}
    if lock_file.exists():
        try:
            with lock_file.open("r") as f:
                lock_data = json.load(f)
        except Exception:
            lock_data = {}

    for key, spec in projects_config.items():
        project = spec.get("project")
        if not project:
            logging.warning(f"Skipping {key}: 'project' not specified")
            continue

        game_versions = spec.get("game_versions")
        if isinstance(game_versions, str):
            game_versions = [game_versions]

        loaders = spec.get("loaders")
        if isinstance(loaders, str):
            loaders = [loaders]

        version_type = spec.get("version_type")

        logging.info(f"Fetching updates for '{key}' (project: {project})...")
        try:
            versions = fetch_project_versions(
                session=session,
                project=project,
                game_versions=game_versions,
                loaders=loaders,
            )
            if not versions:
                logging.warning(f"No versions found matching constraints for '{key}'")
                continue

            if version_type:
                matching_versions = [
                    v for v in versions if v.get("version_type") == version_type
                ]
                if matching_versions:
                    selected_version = matching_versions[0]
                else:
                    logging.warning(
                        f"No versions matching version_type='{version_type}' for '{key}', falling back to newest"
                    )
                    selected_version = versions[0]
            else:
                selected_version = versions[0]

            file_info = select_file(selected_version.get("files", []))
            hashes = file_info.get("hashes", {})

            entry: Dict[str, Any] = {
                "project_id": selected_version.get("project_id"),
                "version_id": selected_version.get("id"),
                "version_number": selected_version.get("version_number"),
                "filename": file_info.get("filename"),
                "url": file_info.get("url"),
                "size": file_info.get("size"),
            }

            # Store hashes without transformation
            for algo in ["sha512", "sha1", "sha256"]:
                if algo in hashes:
                    entry[algo] = hashes[algo]

            lock_data[key] = entry
            logging.info(
                f"Updated '{key}': version {entry['version_number']} ({entry['filename']})"
            )

        except Exception as e:
            logging.error(f"Failed to update '{key}': {e}")

    with lock_file.open("w") as f:
        json.dump(lock_data, f, indent=2)
        f.write("\n")

    logging.info(f"Successfully saved lock data to {lock_file}")


def main() -> None:
    repo_root = Path.cwd()
    modrinth_dir = repo_root / "sources" / "modrinth"
    projects_file = modrinth_dir / "projects.json"
    lock_file = modrinth_dir / "lock.json"

    session = make_session()
    update_modrinth_sources(projects_file, lock_file, session)


if __name__ == "__main__":
    main()
