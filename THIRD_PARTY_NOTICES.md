# Third-party notices and inventory

Hero of the Two Worlds' original project material is attributed to Cartesian Graphics under the [root notice](LICENSE). Third-party material retains its respective rights holders and licences. Nothing in this document expands the proprietary notice to cover upstream material.

## Inspection scope

The repository `giasonpooni/Hero-of-the-Two-Worlds` was empty when inspected on 2026-09-28: the branches endpoint returned an empty list and the contents endpoint reported an empty repository. A minimal README was then added to initialize `main` at commit `477eba2e20737fc9df618f4b109af35cbe9282af` for this licensing change. That baseline contains only `README.md`.

This package adds licensing documentation, not a game scaffold. No engine binary, Godot project, executable game code, vendored library, package lockfile, imported media, or font is included in the inspected baseline or this licensing package. There is no project dependency inventory to certify yet.

This is a bounded repository inspection, **not** an audit of work in other branches, local or ignored files, separate repositories, privately held assets, or future builds. The copyright attribution follows the owner's instruction; these notices do not independently establish an ownership chain. Reinspect incoming code and assets before integration or distribution.

## Reference-only Godot Engine notice

An unmodified copy of Godot Engine's MIT notice is retained at [Godot-MIT.txt](licenses/third-party/Godot-MIT.txt) to match the shared licensing structure. **Its inclusion is not a claim that Godot is installed, integrated, or distributed by this repository.** It does not licence the game's original code or assets under MIT.

The copy comes from [Godot's `4.5.1-stable` LICENSE.txt](https://github.com/godotengine/godot/blob/4.5.1-stable/LICENSE.txt), upstream blob `0e3ba08d6b2e8cf435241829c96f10b74e4356fe`. That identifies the notice's provenance; it does not select or pin an engine version for this project. The upstream attribution is preserved in the notice file, not replaced with Cartesian Graphics.

Godot's official [licensing page](https://godotengine.org/license/) distinguishes its engine licence from game content. Its [licence-compliance guide](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html) describes distribution obligations.

**When a Godot-based build is distributed:** review the exact engine and export-template versions, include their required notices, and retain the notices for bundled third-party libraries, fonts, and other components. The main MIT text alone is not an exhaustive notice bundle for all engine dependencies. This change does not implement export packaging or runtime credits.

## Other engines, tools, and shared technology

No Bevy, Blender, Notations Engineering Terminal, or 1792 implementation is incorporated by this package. These or other tools may be integrated separately; their applicable licences, ownership, and distribution requirements must be reviewed for the actual versions and material used. This project's proprietary notice does not relicense another repository. Applying the same licensing policy to two projects does not itself share their code or assets.

## Additions and release review

For each incoming third-party component, record the exact repository paths, upstream source, pinned revision or version, actual copyright holder, licence identifier and text, modifications, and release obligations. Retain permission evidence privately where necessary. Follow [asset intake](docs/ASSET_LICENSING.md) for media and [contribution review](CONTRIBUTING.md) for externally authored code.

Unresolved rights are not cleared by this inventory. Preserve applicable upstream terms and obtain review before combining licences that could conflict with the intended distribution.
