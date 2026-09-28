# Validation scope

## Content checks

`python tools/validate.py` checks JSON syntax and finite numeric values, schema validity, source-ID resolution, chapter chronology and Godot resource paths. `python -m unittest discover -s tests -p 'test_*.py' -v` executes negative contract tests and README link checks.

These checks do not run GDScript, verify historical truth, inspect visuals or prove export compatibility.

## Engine checks

`python tools/check_godot.py --godot <path>` runs three commands in order:

```text
Godot --headless --path . --editor --import
Godot --headless --path . --script res://tests/test_world_state.gd
Godot --headless --path . --quit-after 30
```

The wrapper uses timeouts and fails for nonzero exits or logged engine/script errors. Runtime checks cover mission ordering, idempotence, snapshot isolation, finite transforms, save replacement, round-trip equality, malformed saves, version/project mismatches and provenance consistency.

The GitHub Actions workflow repeats these checks with Godot 4.5.1, downloaded from the official build release and checked against that release's published SHA-512 sums. Checkout is pinned; workflow permissions are read-only. Validation is not a deployment or game release.

## Manual checks still needed

Walk the complete errand without teleporting. Verify marker range, wall collision, camera occlusion, readable UI at the documented viewport, saved-position restoration, missing-save messaging and mouse release/capture. A primitive ship in the scene is not a naval simulation.

Rendering quality, accessibility, controller support, exported builds, platform packaging and historical authenticity are not certified by headless tests. Record actual engine version and command results when reporting a run; a workflow file alone is not evidence that CI passed.
