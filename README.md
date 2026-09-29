# Hero of the Two Worlds

**Begin as a young sailor. Cross oceans, build trust and grow into command.**

A Cartesian Graphics historical biographical sandbox about Giuseppe Maria Garibaldi. This is a secondary project, developed gradually alongside **1792**, the primary game.

**Current status: an early Godot harbour greybox with one fictional errand—not a finished open-world game.**

[Run](#run-the-prototype) · [Full development reference](DEVELOPMENT_REFERENCE.md) · [Game design](docs/GAME_DESIGN.md) · [Historical method](docs/HISTORICAL_METHOD.md) · [Rights](docs/RIGHTS.md)

## Cartesian Graphics and Notation Systems

**Cartesian Graphics — Private Creative, Simulation and Commercial IP Programme.** The game is a creative product in its own right.

The proposed institutional direction places Cartesian Graphics as the private ownership/commercialization layer above a **Notation Systems public-interest scientific instrumentation commons**. That is a governance direction, not a claim that a legal parent/subsidiary relationship, nonprofit entity or IP transfer already exists.

[Notations Terminal](https://github.com/giasonpooni/Notations-Systems-Terminal) supplies shared scientific instrumentation. The game retains its own authored content, schemas, live state, clock, saves, historical interpretation and release approval.

## Run the prototype

Import the root `project.godot` in **Godot 4.5.1 Standard** and press **F5**, or run:

```sh
godot --path .
```

No account, API key, .NET SDK, Python environment or external Terminal is needed to play.

**WASD** moves, **Shift** runs, **mouse** looks and **E** interacts. **Esc** releases the mouse; **left click** captures it. During play, **F5 saves** and **F9 loads**.

Accept the dock errand, collect the manifest at the storehouse, deliver it to the captain and report back. The vessel is scenery; sailing and campaign transitions are not implemented. Save path: `user://harbour-save.v1.json`. The current harbour is authored connective material, not a documented historical incident.

## Creative development and research

First make the harbour loop convincing. Later, this title can test whether production workflows developed around 1792 transfer to another game without replacing the workbench.

Games/simulation are valuable to the instrumentation commons because an engine can expose controlled synthetic ground truth, partial observations and exact state transitions. That permits bounded experiments in estimation, mapping, delayed information and agent reasoning. It does not establish simulation-to-reality validity.

Game Foundry belongs on NET; Godot keeps live game state and saves, while creative direction and release approval stay game-owned. Measure adaptation, setup, supervision, build cost, rework and accepted playable output.

Python, Julia, Rust and C++ are optional specialist implementation choices. CUDA requires a separately implemented and measured provider.

[Research protocol](https://github.com/giasonpooni/Notations-Systems-Terminal/blob/docs/coupled-game-foundry-scope-20260929/RESEARCH_PROGRAMME.md).

## Check the scaffold

Python 3.11+ is required only for developer validation:

```sh
python -m pip install -r requirements-dev.txt
python tools/validate.py
python -m unittest discover -s tests -p 'test_*.py' -v
python tools/check_godot.py --godot godot
```

[Validation scope](docs/VALIDATION.md) · [Roadmap](docs/ROADMAP.md) · [Architecture](docs/ARCHITECTURE.md)

## Preserved documentation and rights

The full previous README is preserved byte-for-byte in [DEVELOPMENT_REFERENCE.md](DEVELOPMENT_REFERENCE.md).

This update changes no code, assets, tests, workflows, engine pins, licences or release status. The proposed institutional inversion transfers no existing rights. Consult [RIGHTS.md](docs/RIGHTS.md) and applicable repository/third-party terms.
