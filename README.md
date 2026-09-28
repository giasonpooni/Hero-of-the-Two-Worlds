# Hero of the Two Worlds

**Copyright (c) 2026 Cartesian Graphics. All rights reserved.** Original project material is proprietary; see [licensing](#licensing).

Project repository for **Hero of the Two Worlds**.

## Shared four-language architecture

All Cartesian Graphics games, including this title, will use the **C++ - Rust - Python - Julia** architecture: C++ for qualified native kernels, Rust for runtime systems, Python/NET for orchestration and retained experiments, and Julia for reference mathematics and numerical providers. Godot remains the playable application; Blender remains the authoring environment.

The [shared architecture baseline](docs/SHARED_GAME_ARCHITECTURE.md) defines single-writer state ownership, existing NET/`ciw`/SCR integration, native boundaries, development/shipping profiles and qualification requirements. This is a development commitment, not a claim that all four language integrations already run in this checkout. Existing gameplay, specialist providers and licences are preserved; no frame must pass through all four languages.

## Licensing

Hero of the Two Worlds' original game code, authored content, and creative assets are proprietary to **Cartesian Graphics**, subject to the scope and exclusions in [LICENSE](LICENSE). Public repository access is not an open-source licence; applicable law, existing licences, and GitHub's hosting terms remain unaffected.

Selected reusable technology may be released separately under MPL-2.0 or Apache-2.0, but **no component is designated under either licence by this change**. Third-party material retains its own ownership and terms. The retained Godot MIT notice is a reference-only copy, not a claim that an engine or playable game is included.

See the [licensing policy](docs/LICENSING.md), [asset terms](docs/ASSET_LICENSING.md), [third-party notices](THIRD_PARTY_NOTICES.md), and [contribution policy](CONTRIBUTING.md). These notices are not a player EULA or an automatic copyright assignment.

## Repository status

Licensing and architecture foundation only. The four-language architecture is the development baseline; this documentation change does not add gameplay, a historical campaign, an engine integration, or imported assets.
