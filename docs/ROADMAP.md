# Roadmap and acceptance gates

## M0 — Harbour foundation (this scaffold)

Delivered as code: root Godot project, primitive scene, third-person controller, one errand, a local trust result, save/load, content validation and runtime regression tests.

Acceptance: project imports; the scene runs without engine errors; every errand transition can be reached in order; interaction requires proximity; repeated completion awards no extra trust; save/load preserves position and progress; corrupted saves do not destroy the session. Headless tests cannot certify camera comfort or fun.

## M1 — Comfortable first playable

Add visible facing, interaction highlighting, clearer route cues, a remappable input screen, camera settings, a pause menu and a restart action. Replace only the geometry needed for readability. Add an in-engine proximity test and manual keyboard/mouse checks on supported desktop targets.

Gate: someone unfamiliar with the repository completes the loop from the HUD alone and can reliably save and resume.

## M2 — One maritime behaviour

Choose one: board a stationary vessel, handle a mooring interaction, or navigate a tiny controlled water area. Implement its state ownership, collision and save behaviour before adding weather, combat or many ship classes.

Gate: land-to-vessel interaction does not duplicate player control or lose state.

## M3 — One social consequence and information journey

Implement one contact with a dated role and one delayed report. Separate what happened from what the player has been told. Include a false or stale report test without requiring a full intelligence framework.

Gate: the same consequence survives leaving the area and returning; knowledge is not omniscient.

## M4 — First South American regional slice

Choose one small, researched operation or fictional connective mission within a documented period. Add the needed companion and supply behaviours, not a full continental map. Research Anita's independent role before assigning dialogue or command.

Gate: the region transition explicitly advances time and carries only declared state.

## M5 — Bounded command

Add a small volunteer group, a limited order vocabulary, supply cost and delayed results. A subordinate playable story must write back to the same campaign. Only introduce Bevy or NET when a concrete workload or experiment justifies an adapter.

Gate: there is one state owner per entity, no duplicated outcomes, and visible historical/invented boundaries.

There is no release date or claim of production readiness in this plan.
