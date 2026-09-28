# Contributing

Run the content validator and tests before submitting a change. For scene or GDScript changes, also run `tools/check_godot.py` and describe the manual playtest. When an engine is unavailable, say that runtime checks were not run rather than claiming a pass.

Prefer one playable slice, a clear acceptance test and a small diff. Add a regression test when fixing a state or save bug. Do not regenerate unrelated files or introduce a service, shared engine or language runtime without a concrete need.

Keep README status honest. A design document, interface sketch or manifest entry is not an implemented game feature. Keep invented dialogue and scenery labelled. Cite sources for newly introduced historical claims and resolve asset rights before importing assets.

Do not change licensing, repository visibility or external deployment settings as part of ordinary development. Licensing is handled separately; preserve the repository's published terms.
