# Hero of the Two Worlds

**Begin as a young sailor. Cross oceans, build trust and grow into command.**

A Cartesian Graphics historical biographical sandbox about Giuseppe Maria Garibaldi. This is a secondary project, developed gradually alongside **1792**, the primary game.

**Current status: an early Godot harbour greybox with one fictional errand—not a finished open-world game.**

[Run](#run-the-prototype) · [Full development reference](DEVELOPMENT_REFERENCE.md) · [Game design](docs/GAME_DESIGN.md) · [Historical method](docs/HISTORICAL_METHOD.md) · [Rights](docs/RIGHTS.md)

## Cartesian Graphics

**Interactive Worlds, Simulation Technology and Digital IP.** Cartesian Graphics develops games and the graphics, assets, simulation and production technology behind them. The game is a creative product in its own right, not merely a tooling benchmark.

**Notation Systems — Frontier Tooling and Instrumentation for Digital Futures.** Its instruments and [Notations Terminal](https://github.com/giasonpooni/Notations-Systems-Terminal) support shared development workflows. Public-interest tooling and private creative/IP work remain distinct. This wording establishes no new legal entity, nonprofit status, ownership transfer or licence grant.

## Run the prototype

Import the root `project.godot` in **Godot 4.5.1 Standard** and press **F5**, or run:

```sh
godot --path .
```

No account, API key, .NET SDK, Python environment or external Terminal is needed to play. Use the actual path to your installed Godot executable where required.

**WASD** moves, **Shift** runs, **mouse** looks and **E** interacts. **Esc** releases the mouse; **left click** captures it. During play, **F5 saves** and **F9 loads**.

Accept the dock errand, collect the manifest at the storehouse, deliver it to the captain and report back. The vessel is scenery; sailing and campaign transitions are not implemented. Save path: `user://harbour-save.v1.json`. The current harbour is authored connective material, not a documented historical incident.

## Creative development and research

First make the harbour loop convincing. Later, the title can test whether production workflows developed around 1792 transfer to another game without replacing the workbench. Game Foundry belongs on NET; Godot keeps live game state, clock and saves, while creative direction and release approval stay game-owned.

Measure adaptation, setup, supervision, build cost, rework and accepted playable output. Preserve failed attempts and separate automated checks from artistic review and historical claims. No cross-title productivity multiplier, GPU speedup or autonomous production capability is established by this scaffold.

Python, Julia, Rust and C++ are optional specialist implementation choices, not four mandatory live runtimes. CUDA requires a separately implemented and measured provider.

[Research protocol](https://github.com/giasonpooni/Notations-Systems-Terminal/blob/b41b84922d4963a9206202029afd1e78b9451f9c/RESEARCH_PROGRAMME.md) · [Organization profile](https://github.com/giasonpooni/Notations-Systems-Terminal/blob/b41b84922d4963a9206202029afd1e78b9451f9c/PUBLIC_POSITIONING.md)

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

The full previous README is preserved byte-for-byte in [DEVELOPMENT_REFERENCE.md](DEVELOPMENT_REFERENCE.md), using the original Git blob at the same root-relative base. It retains the complete controls, historical method, campaign targets, architecture, layout and rights discussion.

This update changes no code, assets, tests, workflows, engine pins, licences or release status. Consult [RIGHTS.md](docs/RIGHTS.md) and the applicable repository and third-party terms. Separate documented history, reconstruction, gameplay abstraction and original fiction. No material from another game or archive is imported here.
