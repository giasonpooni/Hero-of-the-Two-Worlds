# Instructions for coding agents

## Project boundaries

Build a person-first Garibaldi biographical game. Godot owns the playable application. This is a sister project to 1792, not its code fork or its runtime dependency. Do not access or copy sibling private assets automatically.

## Work in bounded slices

Read README.md and the affected scripts before editing. Preserve working behaviour and save compatibility or version the contract explicitly. Keep one writer per state. Do not add Bevy, NET, Julia, C++ or a generic agent framework without a measured need and an explicit task.

## Evidence and checks

Run `python tools/validate.py`, `python -m unittest discover -s tests -p 'test_*.py' -v`, and engine checks for runtime changes. Report actual results and limitations. Never call a scene playable solely because JSON validation passed.

Separate documented history, reasonable reconstruction, gameplay abstraction and fictional connective material. Source the claim, not just the surrounding chapter. Do not transplant later political actors, flags, personal impairments or named ships into early scenes without evidence.

## Security and rights

Do not commit credentials, .env files, personal data, generated engine caches, unlicensed media or large unrelated corpora. Do not alter licensing or publish a hosted build as a side effect. No runtime network access is required by the scaffold.
