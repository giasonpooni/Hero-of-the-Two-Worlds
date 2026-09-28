# Asset pipeline

The scaffold renders original engine primitives. There are no imported models, textures, portraits, music, fonts, animation clips or archive images.

The planned authoring path is Blender → reviewed export → Godot. Use metres for scene-scale modelling, verify scale and orientation in Godot, and keep source files separate from runtime exports. Add a tiny known-scale test asset before building an exporter.

Every external asset must carry provenance and exact permission/attribution notes. Never copy a commercial game's content because it is a visual reference. Do not add large binary packs or Git LFS rules until real assets justify them.
