extends RefCounted
## One owner for the prototype's persistent state. No scene or engine singleton dependency.

const SEED_PATH := "res://data/world/nizza_1824.json"
const STAGES := ["available", "accepted", "collected", "delivered", "complete"]
const EVENTS := ["accepted_errand", "collected_manifest", "delivered_manifest", "returned_to_contact"]
const MAX_SAVE_BYTES := 1048576
var _state: Dictionary = {}
var last_error: String = ""

func _init() -> void:
	if not load_text(FileAccess.get_file_as_string(SEED_PATH)):
		push_error("Cannot load the world seed: " + last_error)

func snapshot() -> Dictionary:
	return _state.duplicate(true)

func stage() -> String:
	return str(_state["mission"]["stage"])

func elapsed() -> float:
	return float(_state["elapsed_seconds"])

func advance(seconds: float) -> void:
	if is_finite(seconds) and seconds >= 0.0:
		_state["elapsed_seconds"] = minf(elapsed() + seconds, 1000000000.0)

func set_player_transform(point: Vector3, heading: float) -> bool:
	if not point.is_finite() or not is_finite(heading):
		return false
	for value in [point.x, point.y, point.z, heading]:
		if absf(value) > 1000000.0:
			return false
	_state["player"]["position"] = [point.x, point.y, point.z]
	_state["player"]["heading_radians"] = heading
	return true

func objective() -> String:
	match stage():
		"available": return "Speak to the dock contact beside the quay."
		"accepted": return "Collect the manifest outside the storehouse."
		"collected": return "Take the manifest to the captain by the pier."
		"delivered": return "Return to the dock contact."
		_: return "Errand complete. Explore the harbour or save your progress."

func interact(target: String) -> String:
	# The scene checks distance. This bounded state transition contains no movement authority.
	match target:
		"dock_contact":
			if stage() == "available":
				_transition("accepted", false, "accepted_errand")
				return "Dock contact: Fetch the manifest from the storehouse, then find the captain."
			if stage() == "delivered":
				_transition("complete", false, "returned_to_contact")
				_state["relationships"]["dock_contact"] = 1
				return "Dock contact: Dependable work. We will remember it. Local trust +1."
			return "Dock contact: " + objective()
		"storehouse":
			if stage() == "accepted":
				_transition("collected", true, "collected_manifest")
				return "You collect the manifest. These papers and this errand are fictional."
			return "Storehouse: " + objective()
		"captain":
			if stage() == "collected":
				_transition("delivered", false, "delivered_manifest")
				return "Captain: The papers are in order. Tell the dock contact we have them."
			return "Captain: " + objective()
	return "There is nothing to do here."

func _transition(next_stage: String, carrying: bool, event_id: String) -> void:
	_state["mission"]["stage"] = next_stage
	_state["mission"]["has_manifest"] = carrying
	_state["journal"].append(event_id)

func load_text(text: String) -> bool:
	last_error = ""
	if text.to_utf8_buffer().size() > MAX_SAVE_BYTES:
		last_error = "Save exceeds the 1 MiB prototype limit."
		return false
	var parser := JSON.new()
	if parser.parse(text) != OK:
		last_error = "Invalid JSON: " + parser.get_error_message()
		return false
	if not _valid(parser.data):
		last_error = "Unsupported or inconsistent world-state.v1 for this scenario."
		return false
	_state = parser.data.duplicate(true)
	# JSON has one numeric type; restore this contract's integer fields explicitly.
	_state["year"] = int(_state["year"])
	_state["relationships"]["dock_contact"] = int(_state["relationships"]["dock_contact"])
	return true

func load_file(path: String) -> bool:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Cannot open save: " + error_string(FileAccess.get_open_error())
		return false
	if file.get_length() > MAX_SAVE_BYTES:
		last_error = "Save exceeds the 1 MiB prototype limit."
		return false
	return load_text(file.get_as_text())

func save_file(path: String) -> Error:
	var temporary := path + ".tmp"
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	# Retain full floating-point precision across disk round-trips.
	file.store_string(JSON.stringify(_state, "\t", true, true))
	file.flush()
	var result := file.get_error()
	file.close()
	if result != OK:
		DirAccess.remove_absolute(temporary)
		return result
	# Same-directory replacement; a failed rename leaves the old save intact.
	result = DirAccess.rename_absolute(temporary, path)
	if result != OK:
		DirAccess.remove_absolute(temporary)
	return result

func _keys(value: Variant, expected: Array) -> bool:
	if not value is Dictionary or value.size() != expected.size():
		return false
	for key in expected:
		if not value.has(key):
			return false
	return true

func _number(value: Variant, low: float, high: float) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= low and value <= high

func _valid(value: Variant) -> bool:
	if not _keys(value, ["schema_version", "project_id", "scenario_id", "timeline_mode", "year", "elapsed_seconds", "player", "mission", "relationships", "journal", "provenance"]):
		return false
	if value["schema_version"] != "world-state.v1" or value["project_id"] != "hero-of-the-two-worlds":
		return false
	if value["scenario_id"] != "nizza_harbour_1824" or value["timeline_mode"] != "biographical":
		return false
	if not _number(value["year"], 1824, 1824) or not _number(value["elapsed_seconds"], 0, 1000000000):
		return false
	var player: Variant = value["player"]
	if not _keys(player, ["person_id", "position", "heading_radians"]):
		return false
	if player["person_id"] != "giuseppe_garibaldi" or not player["position"] is Array or player["position"].size() != 3:
		return false
	for coordinate in player["position"]:
		if not _number(coordinate, -1000000, 1000000):
			return false
	if not _number(player["heading_radians"], -1000000, 1000000):
		return false
	var mission: Variant = value["mission"]
	if not _keys(mission, ["id", "stage", "has_manifest"]):
		return false
	if mission["id"] != "harbour_errand" or not mission["stage"] in STAGES or not mission["has_manifest"] is bool:
		return false
	if mission["has_manifest"] != (mission["stage"] == "collected"):
		return false
	var index: int = STAGES.find(mission["stage"])
	if not value["journal"] is Array or value["journal"] != EVENTS.slice(0, index):
		return false
	if not _keys(value["relationships"], ["dock_contact"]):
		return false
	var trust: int = 1 if mission["stage"] == "complete" else 0
	if not _number(value["relationships"]["dock_contact"], trust, trust):
		return false
	# Preserve the seed's historical/fiction distinction across save round-trips.
	var seed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SEED_PATH))
	return seed is Dictionary and value["provenance"] == seed["provenance"]
