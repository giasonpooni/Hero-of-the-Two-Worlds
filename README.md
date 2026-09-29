# Hero of the Two Worlds

## Current production priority and historical style

**Slow secondary development.** 1792 remains the primary game workload;
Garibaldi is the secondary title and a test of shared production-workflow reuse.
Geronimo is on hold. Existing harbour work is preserved, not restarted.

Garibaldi is an **entry point into connected lives**, not the boundary of the
historical world. Discover other people through encounters, relationships,
correspondence, obligations and consequences. Preserve what each actor could
know at the moment of choice rather than granting them retrospective hindsight.
Plausible private beliefs and motives remain reconstructions, not historical facts.

[Connected lives, perspective boundaries and the first transfer contract](docs/HISTORICAL_PERSPECTIVE.md).
The shared authoring tool is available in
[Terminal PR #70](https://github.com/giasonpooni/Notations-Systems-Terminal/pull/70)
as `net history`. **It is not yet attached to this game's runtime.** It checks
explicit annotations and received-information declarations, not the truth of
historical psychology or the meaning of arbitrary dialogue.

---

**A historical biographical sandbox about Giuseppe Maria Garibaldi.**

Begin as a young sailor. Cross oceans, live in exile, build trust, gather volunteers, and grow into command—without losing the ability to walk through the world as one person.

This is a sister project to **1792**, the Ranjit Singh / Buddh Singh biopic. It shares the person-first, persistent-world design philosophy, not its setting, historical factions, source code, or a claim of save compatibility.

> **Build one convincing harbour before building two continents.**

## What is here now?

**An early Godot scaffold with a small third-person harbour greybox and one fictional errand.** This is not a finished open-world game or a full historical reconstruction.

| Implemented in this scaffold | Planned, not implemented |
| --- | --- |
| Walking, running, mouse-look camera, collision | Sailing, riding, combat and stealth |
| A primitive quay, storehouse and moored vessel | Historical cities, ships, terrain and character art |
| Three labelled interaction points | Dialogue trees, companions and autonomous NPC schedules |
| Accept → collect → deliver → return errand | Volunteer recruitment, faction politics and command |
| Persistent mission progress, position, local trust and journal | Campaign transitions, ageing and injury systems |
| Versioned save/load, JSON contracts and automated checks | Bevy, NET and other external integrations |

The current scene is a **fictional Nice/Nizza harbour vignette set in 1824**. The year has a biographical basis in Garibaldi's early maritime career; the map, contacts, papers and dialogue are authored connective material, not a documented incident. See [Historical method](docs/HISTORICAL_METHOD.md) and the [source register](data/history/sources.json).

## Run the prototype

Use **Godot 4.5.1 Standard** as the pinned baseline. It is not a claim that this is the newest release. No .NET SDK, Blender installation, Python environment, account, or API key is needed to play this scaffold.

Clone this repository, import the **root `project.godot`** in Godot, and press **F6** with the harbour scene open or **F5** to run the project. Alternatively, from the repository root:

```sh
godot --path .
```

`godot` means your installed executable. On Windows, use its actual path, for example in PowerShell:

```powershell
& 'C:\Tools\Godot\Godot_v4.5.1-stable_win64.exe' --path .
```

### Controls and first errand

**WASD** moves, **Shift** runs, **mouse** looks, and **E** interacts when you are near a label. **Esc** releases the mouse; **left click** captures it again. While playing, **F5 saves** and **F9 loads**. Close the game window to quit.

Walk to the dock contact, collect the manifest at the storehouse, take it to the captain, and return to the contact. Completion adds one local trust point. Repeating the last interaction does not duplicate the reward.

The save lives at `user://harbour-save.v1.json` in Godot's per-user application-data directory, not inside the checkout. Load failures keep the current session. The vessel is scenery: there is no boarding or sailing mechanic yet. The prototype clock measures session time; it is not a day/night or calendar simulation.

## The game we are building toward

```text
sailor → exile → irregular commander → volunteer general → political symbol
```

The long-term design joins an embodied world with increasingly consequential command. Coastal travel, ports, countryside, camps, conversations, reconnaissance and small actions should remain meaningful after the player acquires an army.

**Seamanship and mobility.** Routes, weather, vessels and the ability to get people and supplies somewhere matter as much as a coloured area on a map.

**Volunteers rather than interchangeable units.** Recruitment, commitment, fatigue, trust, language and material support shape a force. Anita and other historical participants should have agency and their own evidence-backed records, not function as upgrade slots.

**Command with incomplete information.** Reports travel through people. Orders take time. A successful subordinate mission changes the same campaign state as the main character's actions.

**Political success is not personal sovereignty.** Military capability, popular support, republican commitments, state authority and foreign intervention are separate pressures. Later chapters should make room for compromise, retreat and the cost of victory—not only territorial accumulation.

These are **design targets**, not claims about working systems. [Game design](docs/GAME_DESIGN.md) turns them into bounded development slices.

## Two worlds, connected chapters

The proposed campaign is recorded as data in [chapters.json](data/campaign/chapters.json): maritime beginnings, conspiracy and exile, South America, return and the Roman Republic, a second exile, the volunteer army, later campaigns, and Caprera.

**Only the harbour greybox exists.** The chapter titles, year ranges and gameplay themes are planning choices grounded in a broad biography, not a researched mission script. Detailed chronology belongs in the research layer. [Campaign plan](docs/CAMPAIGN.md)

The target is **connected regional sandboxes with explicit voyages and time jumps**, not one seamless map of Europe and South America. Persistent identity, relationships, consequences and provenance carry between regions; what is carried across a time jump must be explicitly defined.

## Architecture

```text
Blender / authored content
          │ reviewed, exported assets
          ▼
Godot — playable application and current world-state owner
          │ versioned snapshots / commands (future adapters)
          ├── Bevy / Rust: bounded large-scale simulation, when justified
          └── NET / Python: external experiments, replay and validation
```

**Godot owns gameplay now.** The state model is separate from the 3D scene so its transitions can be tested headlessly. There is no second simulation authority and no dependency on another personal repository.

**Blender is the planned asset-authoring path.** Bevy and Notations Engineering Terminal are future integration points, not installed dependencies. Julia or C++ kernels should only be introduced for a measured workload; they are not required to make this harbour run.

The contract uses `world-state.v1` plus an explicit `project_id`. Sharing a version label with 1792 does **not** make the schemas interchangeable. [Architecture and boundaries](docs/ARCHITECTURE.md)

## Repository map

```text
project.godot             Import this file; repository root is res://
game/scenes/             Player and harbour scenes
game/scripts/            Controller, harbour presentation, persistent state
data/world/              The shipped scenario seed
data/campaign/           Planned chapter manifest
data/history/            Sources and research limitations
schemas/                 Versioned JSON contracts
assets/                  Asset pipeline policy; no third-party art bundled
tests/                   Python content tests and Godot runtime regressions
tools/                   Content validator and headless check runner
docs/                    Design, campaign, history, rights and milestones
.github/workflows/       Automated validation
```

## Check the scaffold

Python **3.11+** is for developer validation only:

```sh
python -m pip install -r requirements-dev.txt
python tools/validate.py
python -m unittest discover -s tests -p 'test_*.py' -v
python tools/check_godot.py --godot godot
```

The first two checks validate content and contracts; they do not execute GDScript. The final command imports the project, executes the Godot state tests, and smoke-runs the scene. It fails on engine errors even when Godot returns exit code zero. [Validation scope](docs/VALIDATION.md)

## Development order

Get the harbour loop working comfortably first. Then add one vessel interaction and one grounded social encounter. Only after that should the project grow into the first South American regional slice or larger command systems. [Roadmap and acceptance gates](docs/ROADMAP.md)

Contributions and coding agents should follow [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md). Do not substitute a large framework, generated content catalogue, or dependency stack for a tested piece of the game.

## History, assets and rights

Separate **documented history**, **reasonable reconstruction**, **gameplay abstraction**, and **fictional connective material**. Never turn an unverified anecdote or an invented interaction into a historical fact by putting it in JSON.

This scaffolding change does not select or alter project licensing. Consult the repository-level licensing documents for applicable terms. No source code or artwork from 1792, commercial games, or historical archives has been copied into it. Engine and future third-party asset terms remain separate. [Rights and asset policy](docs/RIGHTS.md)
