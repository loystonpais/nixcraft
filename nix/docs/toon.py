from typing import Any, List, Dict, Optional, Union
import json


def _is_primitive(val: Any) -> bool:
    return val is None or isinstance(val, (bool, int, float, str))


def _format_primitive(val: Any, delimiter: str = ",") -> str:
    if val is None:
        return ""
    if isinstance(val, bool):
        return "true" if val else "false"
    if isinstance(val, (int, float)):
        return str(val)

    val_str = str(val)
    # Check if string needs quoting (contains delimiter, newlines, colons, or leading/trailing whitespace)
    if (
        delimiter in val_str
        or "\n" in val_str
        or "\r" in val_str
        or val_str.startswith(" ")
        or val_str.endswith(" ")
        or val_str in ("true", "false", "null", "")
        or (val_str and val_str[0] in ('"', "'", "{", "}", "[", "]"))
    ):
        # Escape quotes and backslashes
        escaped = (
            val_str.replace("\\", "\\\\")
            .replace('"', '\\"')
            .replace("\n", "\\n")
            .replace("\r", "\\r")
        )
        return f'"{escaped}"'
    return val_str


def _is_uniform_dict_list(val: list) -> bool:
    """Check if a list consists of uniform dictionaries with identical primitive fields."""
    if not val or not isinstance(val, list):
        return False
    if not all(isinstance(item, dict) for item in val):
        return False
    first_keys = list(val[0].keys())
    if not first_keys:
        return False
    # Check that all items have exactly the same keys and primitive values
    for item in val:
        if list(item.keys()) != first_keys:
            return False
        if not all(_is_primitive(v) for v in item.values()):
            return False
    return True


def dumps(data: Any, indent: int = 2, delimiter: str = ",", level: int = 0) -> str:
    """
    Encode Python dictionary or list into TOON format string.

    - Dicts become YAML-style indented key-values.
    - Uniform lists of dicts become tabular arrays: key[N]{col1,col2,...}:
        row1_col1,row1_col2,...
    - Lists of primitives become inline arrays: key[N]: val1,val2,...
    """
    lines = []
    pad = " " * (level * indent)

    if isinstance(data, dict):
        for k, v in data.items():
            if _is_primitive(v):
                formatted = _format_primitive(v, delimiter)
                lines.append(f"{pad}{k}: {formatted}")
            elif isinstance(v, list):
                if not v:
                    lines.append(f"{pad}{k}[0]:")
                elif _is_uniform_dict_list(v):
                    cols = list(v[0].keys())
                    col_str = delimiter.join(cols)
                    lines.append(f"{pad}{k}[{len(v)}]{{{col_str}}}:")
                    sub_pad = " " * ((level + 1) * indent)
                    for row in v:
                        row_vals = [_format_primitive(row[c], delimiter) for c in cols]
                        lines.append(f"{sub_pad}{delimiter.join(row_vals)}")
                elif all(_is_primitive(x) for x in v):
                    prim_vals = [_format_primitive(x, delimiter) for x in v]
                    lines.append(f"{pad}{k}[{len(v)}]: {delimiter.join(prim_vals)}")
                else:
                    lines.append(f"{pad}{k}[{len(v)}]:")
                    for item in v:
                        lines.append(
                            dumps(
                                item,
                                indent=indent,
                                delimiter=delimiter,
                                level=level + 1,
                            )
                        )
            elif isinstance(v, dict):
                lines.append(f"{pad}{k}:")
                sub = dumps(v, indent=indent, delimiter=delimiter, level=level + 1)
                if sub:
                    lines.append(sub)
    elif isinstance(data, list):
        if _is_uniform_dict_list(data):
            cols = list(data[0].keys())
            col_str = delimiter.join(cols)
            lines.append(f"{pad}[{len(data)}]{{{col_str}}}:")
            sub_pad = " " * ((level + 1) * indent)
            for row in data:
                row_vals = [_format_primitive(row[c], delimiter) for c in cols]
                lines.append(f"{sub_pad}{delimiter.join(row_vals)}")
        else:
            for item in data:
                lines.append(
                    dumps(item, indent=indent, delimiter=delimiter, level=level)
                )
    else:
        lines.append(f"{pad}{_format_primitive(data, delimiter)}")

    return "\n".join(lines)
