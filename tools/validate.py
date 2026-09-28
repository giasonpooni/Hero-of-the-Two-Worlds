"""Validate shipped data, semantic links and resource references. No game logic here."""
from __future__ import annotations

import json
import math
import re
from pathlib import Path
from typing import Any
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]


def read_json(path: Path) -> Any:
    def reject_constant(value: str) -> None:
        raise ValueError(f"Non-finite JSON constant: {value}")
    value = json.loads(path.read_text(encoding="utf-8"), parse_constant=reject_constant)
    def finite(item: Any) -> None:
        if isinstance(item, float) and not math.isfinite(item):
            raise ValueError("Non-finite JSON number")
        if isinstance(item, dict):
            for nested in item.values():
                finite(nested)
        elif isinstance(item, list):
            for nested in item:
                finite(nested)
    finite(value)
    return value


def validate_world(value: dict[str, Any]) -> None:
    schema = read_json(ROOT / "schemas/world_state.schema.json")
    Draft202012Validator.check_schema(schema)
    Draft202012Validator(schema).validate(value)


def validate_repo(root: Path = ROOT) -> list[str]:
    errors: list[str] = []
    for path in [*root.glob("data/**/*.json"), *root.glob("schemas/*.json")]:
        try:
            read_json(path)
        except (ValueError, OSError) as exc:
            errors.append(f"{path.relative_to(root)}: {exc}")
    if errors:
        return errors
    for data_path, schema_path in [
        ("data/world/nizza_1824.json", "schemas/world_state.schema.json"),
        ("data/campaign/chapters.json", "schemas/campaign.schema.json"),
    ]:
        schema = read_json(root / schema_path)
        Draft202012Validator.check_schema(schema)
        for error in Draft202012Validator(schema).iter_errors(read_json(root / data_path)):
            errors.append(f"{data_path} {list(error.path)}: {error.message}")
    if errors:
        return errors
    sources = read_json(root / "data/history/sources.json")
    if sources.get("schema_version") != "source-register.v1":
        errors.append("Unsupported source register version")
    ids = [item["id"] for item in sources["sources"]]
    if len(ids) != len(set(ids)):
        errors.append("Duplicate source ID")
    for source in sources["sources"]:
        for required in ["title", "author", "publisher", "source_type", "use", "limitations"]:
            if not source.get(required):
                errors.append(f"Source {source.get('id')} missing {required}")
        if not source.get("url", "").startswith("https://"):
            errors.append(f"Source {source.get('id')} missing HTTPS source URL")
    chapters = read_json(root / "data/campaign/chapters.json")["chapters"]
    if len({c["id"] for c in chapters}) != len(chapters):
        errors.append("Duplicate chapter ID")
    if [c["id"] for c in chapters if c["status"] == "greybox"] != ["seamanship"]:
        errors.append("Only the seamanship chapter has a scene in this scaffold")
    for index, chapter in enumerate(chapters):
        if chapter["start_year"] > chapter["end_year"]:
            errors.append(f"Reversed interval: {chapter['id']}")
        if index and chapter["start_year"] < chapters[index - 1]["start_year"]:
            errors.append(f"Chapter order is not chronological: {chapter['id']}")
    world = read_json(root / "data/world/nizza_1824.json")
    for item in [*chapters, world["provenance"]]:
        for source_id in item["source_ids"]:
            if source_id not in ids:
                errors.append(f"Unknown source ID: {source_id}")
    for path in [root / "project.godot", *root.glob("game/**/*.gd"), *root.glob("game/**/*.tscn")]:
        for resource in re.findall(r'"res://([^"\n]+)"', path.read_text(encoding="utf-8")):
            if not (root / resource).is_file():
                errors.append(f"Broken resource in {path.relative_to(root)}: {resource}")
    return errors


if __name__ == "__main__":
    problems = validate_repo()
    for problem in problems:
        print(problem)
    if problems:
        raise SystemExit(1)
    print("Content, chronology, source links and Godot resource paths: PASS")
