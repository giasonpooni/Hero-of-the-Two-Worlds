# Architecture and ownership

## Current execution path

`project.godot` starts `game/scenes/harbour.tscn`. The root script creates the primitive environment, registers controls, checks interaction distance and presents the HUD. `player.gd` owns movement and camera input. `world_state.gd` owns the mission, inventory flag, trust, journal and serialized transform.

The current boundary is deliberately small:

```text
physical input → scene proximity check → state transition → HUD
player transform → snapshot → validated save
saved state → validate completely → replace state → restore player
```

The state class has no autoload dependency. It can be constructed by the scene or by a headless test. It does not need Python or a server. Python validates content; it does not duplicate the game simulation.

## One writer per state

During play, the CharacterBody is the authoritative transform owner. The scene captures that transform before saving. The state class owns campaign-like values. The renderer does not own a separate mission state. The saved position is a snapshot, not a second continuously evolving physics body.

`world-state.v1` identifies this prototype's contract only together with `project_id`, `scenario_id` and its schema. The loader rejects unsupported projects, years, versions, malformed transforms, inconsistent mission state and changes to the scenario's historical classification. It validates before replacing active state and does not silently upgrade saves.

Trust is a single local errand result. The journal is an ordered list of four possible authored events. Neither is a generalized social simulation or a full replay log. Physics replay and cross-engine determinism are not promised.

## Resource root

The repository root is the Godot project root. Runtime content under `data/` is therefore addressable as `res://data/...`; there are no parent-directory reads, symlinks, post-clone copies or duplicate data roots. Future export presets must include required JSON data and exclude tooling, research drafts and source artwork that should not ship.

## Planned specialist integrations

| Component | Future contribution | Must not do |
| --- | --- | --- |
| Blender | Author reviewed models and animations; export assets | Own live campaign state |
| Bevy / Rust | An explicitly delegated simulation workload | Independently advance the same population or factions as Godot |
| NET / Python | Run experiments, inspect reports, compare snapshots | Become a dependency of ordinary play or own the frame loop |
| Julia / C++ | A measured numerical reference or kernel | Enter the critical path merely for language symmetry |

Before integrating any provider, declare its input schema, outputs, version, clock, random seed, ownership handoff and failure behaviour. No provider adapters exist yet.

## Relationship to 1792

Reuse design lessons, terminology and eventually an explicitly versioned, appropriately licensed shared module. Do not copy private files, transplant faction IDs, assume save compatibility, or install 1792 as a runtime dependency. Character and campaign authority remain local to each game.

## Useful next contracts—not implemented

A future observation should distinguish occurrence time, observation time, arrival time, source, confidence and actual player access. A future command should bind actor, recipient, issue time, allowed actions and acknowledgement. A future region transition should specify time advancement and entity carry-over. These require tested consumers before receiving schemas or runtime packages.
