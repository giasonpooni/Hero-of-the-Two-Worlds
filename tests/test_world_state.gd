extends SceneTree

const WorldState = preload("res://game/scripts/world_state.gd")
var checks := 0
var failures := 0

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func _init() -> void:
	var state = WorldState.new()
	check(state.stage() == "available", "Seed stage")
	var original: Dictionary = state.snapshot()
	var copied: Dictionary = state.snapshot()
	copied["player"]["position"][0] = 999
	check(state.snapshot() == original, "Snapshots must not alias state")
	state.interact("captain")
	state.interact("storehouse")
	state.interact("unknown")
	check(state.snapshot() == original, "Out-of-order interactions are no-ops")
	state.interact("dock_contact")
	check(state.stage() == "accepted", "Accept errand")
	state.interact("storehouse")
	check(state.stage() == "collected" and state.snapshot()["mission"]["has_manifest"], "Collect manifest")
	var collected: Dictionary = state.snapshot()
	state.interact("storehouse")
	check(state.snapshot() == collected, "Collection is idempotent")
	state.interact("captain")
	check(state.stage() == "delivered" and not state.snapshot()["mission"]["has_manifest"], "Delivery consumes manifest")
	state.interact("dock_contact")
	check(state.stage() == "complete", "Return completes errand")
	check(state.snapshot()["relationships"]["dock_contact"] == 1, "Completion awards trust")
	var complete: Dictionary = state.snapshot()
	state.interact("dock_contact")
	state.interact("captain")
	check(state.snapshot() == complete, "Rewards cannot be farmed")
	state.advance(12.5)
	state.advance(-10)
	state.advance(NAN)
	check(is_equal_approx(state.elapsed(), 12.5), "Clock rejects negative and nonfinite deltas")
	check(state.set_player_transform(Vector3(3, 1, -4), 0.7), "Save transform")
	check(not state.set_player_transform(Vector3(INF, 0, 0), 0), "Nonfinite position rejected")
	var path := "user://hotw-test-save.json"
	check(state.save_file(path) == OK, "First save")
	state.advance(1)
	check(state.save_file(path) == OK, "Replace existing save")
	var restored = WorldState.new()
	check(restored.load_file(path), "Reload save")
	var actual: Dictionary = restored.snapshot()
	var expected: Dictionary = state.snapshot()
	for key in expected:
		check(actual[key] == expected[key], "Roundtrip field: " + str(key))
	check(actual == expected, "Full save roundtrip")
	var before: Dictionary = restored.snapshot()
	check(not restored.load_text("{broken"), "Corrupt JSON rejected")
	check(restored.snapshot() == before, "Corrupt save does not mutate active session")
	for patch in [{"schema_version": "world-state.v2"}, {"project_id": "1792"}, {"year": 1860}, {"player": []}, {"extra": true}]:
		var invalid: Dictionary = before.duplicate(true)
		invalid.merge(patch, true)
		check(not restored.load_text(JSON.stringify(invalid)), "Invalid structure rejected: " + str(patch))
	check(restored.snapshot() == before, "Validation failure leaves session intact")
	var inconsistent: Dictionary = before.duplicate(true)
	inconsistent["mission"]["has_manifest"] = true
	check(not restored.load_text(JSON.stringify(inconsistent)), "Contradictory mission inventory rejected")
	inconsistent = before.duplicate(true)
	inconsistent["provenance"]["classification"] = "documented_history"
	check(not restored.load_text(JSON.stringify(inconsistent)), "Fiction cannot be loaded as documented history")
	check(not restored.load_text("x".repeat(1048577)), "Oversized saves rejected")
	# Exercise fractional clocks/transforms and every mission stage, not only completion.
	var progression = WorldState.new()
	var actions := ["dock_contact", "storehouse", "captain", "dock_contact"]
	for index in range(5):
		if index > 0:
			progression.interact(actions[index - 1])
		progression.advance(1.0 / 60.0)
		progression.set_player_transform(Vector3(0.1, 0.2, -0.3), 0.123456789012345)
		check(progression.save_file(path) == OK, "Save stage %d" % index)
		var reloaded = WorldState.new()
		check(reloaded.load_file(path), "Load stage %d" % index)
		check(reloaded.snapshot() == progression.snapshot(), "Exact stage %d roundtrip" % index)
	DirAccess.remove_absolute(path)
	print("HOTW runtime: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
