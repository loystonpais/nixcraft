#!/usr/bin/env python3

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

# Add nix/docs to path for local imports
current_dir = Path(__file__).resolve().parent
sys.path.insert(0, str(current_dir))

import toon

try:
    import jinja2
except ImportError:
    jinja2 = None


def get_repo_root() -> Path:
    """Find repository root relative to this script."""
    return Path(__file__).resolve().parent.parent.parent


def evaluate_nix_expr(expr: str, repo_root: Path) -> str:
    """Evaluate a nix expression in the context of the repository flake."""
    try:
        cmd = [
            "nix",
            "eval",
            "--impure",
            "--raw",
            "--expr",
            f'let flake = builtins.getFlake "{repo_root}"; in {expr}',
        ]
        result = subprocess.run(
            cmd, capture_output=True, text=True, cwd=repo_root, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        try:
            cmd = ["nix", "eval", "--impure", "--raw", "--expr", expr]
            result = subprocess.run(
                cmd, capture_output=True, text=True, cwd=repo_root, check=True
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e2:
            return f"<!-- Error evaluating nix expr '{expr}': {e2.stderr.strip()} -->"


def verify_nix_syntax(snippet: str) -> None:
    """
    Validate that a Nix code block parses without syntax error.
    Handles complete modules and partial snippets. Throws ValueError if invalid.
    """
    code = snippet.strip()
    if not code:
        return

    # Attempt 1: Direct parse
    res = subprocess.run(
        ["nix-instantiate", "--parse", "--expr", code], capture_output=True, text=True
    )
    if res.returncode == 0:
        return

    # Attempt 2: If partial snippet (e.g., attr definitions), wrap in dummy module
    wrapped = f"{{ ... }}: {{ {code} }}"
    res2 = subprocess.run(
        ["nix-instantiate", "--parse", "--expr", wrapped],
        capture_output=True,
        text=True,
    )
    if res2.returncode == 0:
        return

    # Attempt 3: Wrapped in attrset directly
    wrapped3 = f"{{ {code} }}"
    res3 = subprocess.run(
        ["nix-instantiate", "--parse", "--expr", wrapped3],
        capture_output=True,
        text=True,
    )
    if res3.returncode == 0:
        return

    # If all failed, report the error
    raise ValueError(
        f"Nix syntax validation failed for snippet:\n{code}\n\nError:\n{res.stderr.strip()}"
    )


def load_options_json(options_path: Path) -> dict:
    with open(options_path, "r", encoding="utf-8") as f:
        return json.load(f)


def format_default_value(val) -> str:
    if val is None:
        return ""
    if isinstance(val, dict):
        if "_type" in val and val["_type"] in ("literalExpression", "literalMD"):
            text = val.get("text", "").strip()
            # If multiline or very long, truncate or collapse to avoid breaking single-line markdown lists
            if "\n" in text or len(text) > 80:
                first_line = text.splitlines()[0] if "\n" in text else text[:77] + "..."
                if len(first_line) > 60:
                    first_line = first_line[:57] + "..."
                return f"{first_line} ..."
            return text
        val_str = json.dumps(val)
        if len(val_str) > 80:
            return val_str[:77] + "..."
        return val_str
    val_str = str(val).strip()
    if "\n" in val_str or len(val_str) > 80:
        first_line = (
            val_str.splitlines()[0] if "\n" in val_str else val_str[:77] + "..."
        )
        if len(first_line) > 60:
            first_line = first_line[:57] + "..."
        return f"{first_line} ..."
    return val_str


def clean_description(desc: str) -> str:
    if not desc or "This option has no description" in desc:
        return ""
    lines = [l.strip() for l in desc.splitlines() if l.strip()]
    first_sentence = lines[0] if lines else ""
    first_sentence = first_sentence.replace("\\.", ".")
    return first_sentence


def build_options_tree_data(options: dict) -> dict:
    tree = {}
    for opt_name, info in options.items():
        if opt_name == "_module":
            continue
        parts = opt_name.split(".")
        curr = tree
        for part in parts:
            if part not in curr:
                curr[part] = {"_children": {}, "_info": None}
            curr = curr[part]["_children"]

        node = tree
        for part in parts[:-1]:
            node = node[part]["_children"]
        node[parts[-1]]["_info"] = info
    return tree


def render_human_markdown_tree(tree: dict, indent: int = 0, prefix: str = "") -> list:
    lines = []
    pad = "  " * indent

    for key in sorted(tree.keys()):
        node = tree[key]
        children = node["_children"]
        info = node["_info"]
        full_name = f"{prefix}.{key}" if prefix else key

        type_str = ""
        default_str = ""
        desc_str = ""
        if info:
            raw_type = info.get("type", "")
            raw_default = format_default_value(info.get("default"))
            desc_str = clean_description(info.get("description", ""))

            short_type = raw_type.replace(
                "strings concatenated with “\\n”", "string (multiline)"
            )
            short_type = short_type.replace(
                "attribute set of (submodule)", "attrsOf submodule"
            )
            if short_type:
                type_str = f" *(`{short_type}`)*"
            if raw_default and raw_default not in ['""', "[]", "{}"]:
                default_str = f" *(default: `{raw_default}`)*"

        if children:
            if info and desc_str:
                lines.append(f"{pad}- **`{key}`**{type_str}{default_str} — {desc_str}")
            elif info:
                lines.append(f"{pad}- **`{key}`**{type_str}{default_str}")
            else:
                lines.append(f"{pad}- **`{key}`**")
            lines.extend(render_human_markdown_tree(children, indent + 1, full_name))
        else:
            desc_part = f" — {desc_str}" if desc_str else ""
            lines.append(f"{pad}- **`{key}`**{type_str}{default_str}{desc_part}")

    return lines


def generate_human_options_tree_md(options: dict) -> str:
    tree = build_options_tree_data(options)
    lines = render_human_markdown_tree(tree, indent=0)
    lines.append("")
    return "\n".join(lines)


def render_agent_toon_tree(node: dict, indent: int = 1) -> list:
    lines = []
    pad = "  " * indent
    for key in sorted(node.keys()):
        child = node[key]
        children = child["_children"]
        info = child["_info"]

        type_str = ""
        default_str = ""
        desc_str = ""

        if info:
            raw_type = info.get("type", "")
            raw_default = format_default_value(info.get("default"))
            desc_str = clean_description(info.get("description", ""))

            short_type = raw_type.replace(
                "strings concatenated with “\\n”", "string (multiline)"
            )
            short_type = short_type.replace(
                "attribute set of (submodule)", "attrsOf submodule"
            )
            short_type = short_type.replace(
                "attribute set of (submodule", "attrsOf submodule"
            )
            if short_type:
                type_str = f"({short_type})"
            if raw_default and raw_default not in [
                '""',
                "[]",
                "{}",
                '"null"',
                "null",
                "",
            ]:
                default_str = f"={raw_default}"

        meta = []
        if type_str:
            meta.append(type_str)
        if default_str:
            meta.append(default_str)
        if desc_str:
            meta.append(f"-- {desc_str}")

        meta_suffix = (" " + " ".join(meta)) if meta else ""

        if children:
            lines.append(f"{pad}{key}{meta_suffix}:")
            lines.extend(render_agent_toon_tree(children, indent + 1))
        else:
            lines.append(f"{pad}{key}{meta_suffix}")
    return lines


def generate_agent_options_tree_toon(options: dict, context: str = "Nixcraft") -> str:
    tree = build_options_tree_data(options)
    lines = [
        "format: TOON",
        "spec: https://github.com/toon-format/spec",
        f"description: {context} hierarchical options tree",
        "options:",
    ]
    lines.extend(render_agent_toon_tree(tree, indent=1))
    lines.append("")
    return "\n".join(lines)


def to_nix_string(val, indent: int = 2, level: int = 0) -> str:
    """Format a Python dict/value as clean, idiomatic Nix syntax."""
    pad = " " * (level * indent)
    inner_pad = " " * ((level + 1) * indent)
    if val is None:
        return "null"
    if isinstance(val, bool):
        return "true" if val else "false"
    if isinstance(val, (int, float)):
        return str(val)
    if isinstance(val, str):
        if "\n" in val:
            lines = val.split("\n")
            return "''\n" + "\n".join(inner_pad + l for l in lines) + "\n" + pad + "''"
        return json.dumps(val)
    if isinstance(val, list):
        if not val:
            return "[ ]"
        items = [to_nix_string(x, indent, level + 1) for x in val]
        return "[\n" + "\n".join(inner_pad + item for item in items) + "\n" + pad + "]"
    if isinstance(val, dict):
        if val.get("_type") == "literalExpression" or val.get("_type") == "raw":
            text = val.get("text", "")
            if "\n" in text:
                lines = text.strip().splitlines()
                # keep first line as is, indent subsequent lines to match inner_pad
                return lines[0] + "\n" + "\n".join(inner_pad + l for l in lines[1:])
            return text
        if not val:
            return "{ }"
        lines = []
        for k in sorted(val.keys()):
            v = val[k]
            key_str = (
                k
                if k.replace("-", "").replace("_", "").isalnum() and not k[0].isdigit()
                else f'"{k}"'
            )
            v_str = to_nix_string(v, indent, level + 1)
            lines.append(f"{inner_pad}{key_str} = {v_str};")
        return "{\n" + "\n".join(lines) + "\n" + pad + "}"
    return str(val)


def render_jinja_template(
    template_path: Path, repo_root: Path, context: dict, verify_nix: bool = True
) -> str:
    """Render a template using Jinja2 with custom Nix filters and block validation."""
    if not jinja2:
        raise RuntimeError(
            "jinja2 is not installed. Please run through Nix or install jinja2."
        )

    template_dir = template_path.parent
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(str(template_dir)),
        autoescape=False,
        trim_blocks=True,
        lstrip_blocks=True,
    )

    def filter_nix_eval(expr: str) -> str:
        return evaluate_nix_expr(expr, repo_root)

    def filter_test_nix(snippet: str) -> str:
        if verify_nix:
            verify_nix_syntax(snippet)
        return snippet

    def filter_to_nix(val) -> str:
        return to_nix_string(val)

    env.filters["nix_eval"] = filter_nix_eval
    env.filters["test_nix"] = filter_test_nix
    env.filters["to_nix"] = filter_to_nix

    template = env.get_template(template_path.name)
    rendered = template.render(**context)

    # Post-render validation: verify all ```nix code blocks in output
    if verify_nix:
        nix_blocks = re.findall(r"```nix\n(.*?)```", rendered, re.DOTALL)
        print(
            f"  [Verifying {len(nix_blocks)} Nix code blocks in {template_path.name}]..."
        )
        for i, block in enumerate(nix_blocks, 1):
            try:
                verify_nix_syntax(block)
            except ValueError as e:
                raise ValueError(
                    f"Block #{i} in {template_path.name} failed Nix verification: {e}"
                )
        print(f"  [All {len(nix_blocks)} Nix code blocks verified successfully!]")

    return rendered


def main():
    parser = argparse.ArgumentParser(
        description="Nixcraft Documentation and Jinja2 Template Engine"
    )
    parser.add_argument(
        "--all", action="store_true", help="Generate all documentation files"
    )
    parser.add_argument(
        "--human", action="store_true", help="Generate docs/human/ files"
    )
    parser.add_argument(
        "--agent", action="store_true", help="Generate docs/agent/ files"
    )
    parser.add_argument(
        "--readme", action="store_true", help="Render README.md from Jinja2 template"
    )
    parser.add_argument(
        "--no-verify-nix", action="store_true", help="Skip Nix code block verification"
    )
    for context in ("nixos", "home-manager", "client", "server"):
        parser.add_argument(
            f"--{context}-options-json", type=str, help=f"Path to {context} options.json"
        )
    parser.add_argument("--examples-json", type=str, help="Path to examples.json")
    parser.add_argument(
        "--readme-template", type=str, help="Path to combined README template"
    )
    parser.add_argument("--repo-root", type=str, help="Repository root path")

    args = parser.parse_args()

    repo_root = Path(args.repo_root) if args.repo_root else get_repo_root()
    human_dir = repo_root / "docs" / "human"
    agent_dir = repo_root / "docs" / "agent"
    readme_dir = repo_root / "nix" / "docs" / "readme"

    human_dir.mkdir(parents=True, exist_ok=True)
    agent_dir.mkdir(parents=True, exist_ok=True)

    do_all = args.all or (not args.human and not args.agent and not args.readme)
    contexts = {
        "nixos": "NixOS module (`nixosModules.default`)",
        "home-manager": "Home Manager module (`homeManagerModules.default`)",
        "client": "Standalone client package instance",
        "server": "Standalone server package instance",
    }
    options_by_context = {}
    for name in contexts:
        path_arg = getattr(args, f"{name.replace('-', '_')}_options_json")
        if path_arg:
            path = Path(path_arg)
            if not path.is_file():
                parser.error(f"Missing {name} options JSON: {path}")
            options_by_context[name] = load_options_json(path)
            if not options_by_context[name]:
                parser.error(f"Empty {name} options JSON: {path}")

    if do_all or args.human or args.agent:
        missing = contexts.keys() - options_by_context.keys()
        if missing:
            parser.error(f"Missing options JSON for: {', '.join(sorted(missing))}")

    options_tree_j2 = current_dir / "docs" / "OPTIONS-TREE.md.j2"
    summary_j2 = current_dir / "docs" / "SUMMARY.md.j2"

    if do_all or args.human:
        target_dir = human_dir / "options-tree"
        target_dir.mkdir(parents=True, exist_ok=True)
        for name, description in contexts.items():
            options = options_by_context[name]
            target = target_dir / f"{name}.md"
            context = {
                "context_name": description,
                "context_key": name,
                "total_options": len(options),
                "options": options,
                "options_tree": generate_human_options_tree_md(options),
            }
            print(f"Rendering {target} from {options_tree_j2}...")
            target.write_text(
                render_jinja_template(
                    options_tree_j2, repo_root, context, verify_nix=not args.no_verify_nix
                ),
                encoding="utf-8",
            )

        summary_target = human_dir / "SUMMARY.md"
        summary_target.write_text(
            render_jinja_template(
                summary_j2, repo_root, {}, verify_nix=not args.no_verify_nix
            ),
            encoding="utf-8",
        )

    if do_all or args.agent:
        target_dir = agent_dir / "options-tree"
        target_dir.mkdir(parents=True, exist_ok=True)
        for name, description in contexts.items():
            target = target_dir / f"{name}.toon"
            print(f"Writing {target}...")
            target.write_text(
                generate_agent_options_tree_toon(options_by_context[name], description),
                encoding="utf-8",
            )

    # 3. Render README.md via Jinja2
    if do_all or args.readme:
        readme_j2 = (
            Path(args.readme_template)
            if args.readme_template
            else (readme_dir / "README.md.j2")
        )
        if readme_j2.exists():
            print(f"Rendering README.md from Jinja2 template {readme_j2}...")

            examples = {}
            if args.examples_json and Path(args.examples_json).exists():
                with open(args.examples_json, "r", encoding="utf-8") as f:
                    examples = json.load(f)

            context = {
                "options_by_context": options_by_context,
                "examples": examples,
            }
            rendered = render_jinja_template(
                readme_j2, repo_root, context, verify_nix=(not args.no_verify_nix)
            )
            target = repo_root / "README.md"
            target.write_text(rendered, encoding="utf-8")
            print(f"Successfully generated and verified {target}")
        else:
            print(f"Template not found at {readme_j2}, skipping README.md render.")

    print("Documentation generation complete!")


if __name__ == "__main__":
    main()
