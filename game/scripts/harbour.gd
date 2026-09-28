extends Node3D
## A deliberately fictional harbour blockout. No historical geometry is asserted.

const WorldState = preload("res://game/scripts/world_state.gd")
const SAVE_PATH := "user://harbour-save.v1.json"
const POINTS := {
	"dock_contact": {"label": "DOCK CONTACT", "position": Vector3(0, 0, -2)},
	"storehouse": {"label": "STOREHOUSE", "position": Vector3(-10, 0, -12)},
	"captain": {"label": "CAPTAIN", "position": Vector3(12, 0, -10)}
}
var world = WorldState.new()
var hud: Label
var feedback := "A fictional errand before a life at sea. Find the dock contact."
@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	_register_inputs()
	_build_harbour()
	_build_hud()
	_restore_transform()
	_update_hud()

func _register_inputs() -> void:
	var bindings := {"move_forward": KEY_W, "move_back": KEY_S, "move_left": KEY_A,
		"move_right": KEY_D, "run": KEY_SHIFT, "interact": KEY_E,
		"save_game": KEY_F5, "load_game": KEY_F9}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action, key)

func _physics_process(delta: float) -> void:
	world.advance(delta)
	if Input.is_action_just_pressed("interact"):
		var target := _nearest_target()
		feedback = world.interact(target) if not target.is_empty() else "Move closer to a labelled contact."
	if Input.is_action_just_pressed("save_game"):
		world.set_player_transform(player.position, player.rotation.y)
		var result: Error = world.save_file(SAVE_PATH)
		feedback = "Saved to " + SAVE_PATH if result == OK else "Save failed: " + error_string(result)
	if Input.is_action_just_pressed("load_game"):
		if world.load_file(SAVE_PATH):
			_restore_transform()
			feedback = "Loaded saved position, errand progress and local trust."
		else:
			feedback = world.last_error + " Current session was kept."
	_update_hud()

func _restore_transform() -> void:
	var saved: Dictionary = world.snapshot()["player"]
	var p: Array = saved["position"]
	player.position = Vector3(p[0], p[1], p[2])
	player.rotation.y = saved["heading_radians"]
	player.velocity = Vector3.ZERO

func _nearest_target() -> String:
	var found := ""
	var nearest := 2.8
	for key in POINTS:
		var distance: float = player.position.distance_to(POINTS[key]["position"])
		if distance < nearest:
			nearest = distance
			found = key
	return found

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := PanelContainer.new()
	panel.position = Vector2(18, 18)
	panel.custom_minimum_size = Vector2(920, 205)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(panel)
	var margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 14)
	panel.add_child(margin)
	hud = Label.new()
	hud.add_theme_font_size_override("font_size", 17)
	margin.add_child(hud)

func _update_hud() -> void:
	var near := _nearest_target()
	var prompt: String = "E — " + str(POINTS[near]["label"]) if not near.is_empty() else "Explore the labelled harbour."
	hud.text = "HERO OF THE TWO WORLDS | NIZZA, 1824 | GREYBOX\n" + \
		"Fictional layout, people and errand; not a reconstructed historical incident.\n" + \
		"WASD walk | Shift run | Mouse look | E interact | F5 save | F9 load\n" + \
		"Esc releases mouse | Left click recaptures | Close window to quit\n\n" + \
		world.objective() + "\n" + prompt + "\n" + feedback

func _build_harbour() -> void:
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = Color(0.45, 0.60, 0.70)
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color(0.8, 0.83, 0.88)
	environment.environment.ambient_light_energy = 0.65
	add_child(environment)
	_box("Quay", Vector3(-4, -0.5, -2), Vector3(42, 1, 46), Color(0.63, 0.59, 0.5))
	_box("Water", Vector3(33, -0.8, -2), Vector3(32, 0.2, 65), Color(0.18, 0.39, 0.5), false)
	_box("Storehouse", Vector3(-14, 2, -17), Vector3(9, 4, 6), Color(0.63, 0.53, 0.4))
	_box("House", Vector3(-15, 2.5, 2), Vector3(8, 5, 8), Color(0.72, 0.65, 0.51))
	_box("Pier", Vector3(21, -0.2, -10), Vector3(12, 0.5, 3), Color(0.39, 0.3, 0.21))
	_box("MooredVessel", Vector3(27, 0, -4), Vector3(4, 1.6, 9), Color(0.30, 0.22, 0.16), false)
	_box("Mast", Vector3(27, 4, -4), Vector3(0.25, 7, 0.25), Color(0.3, 0.24, 0.18), false)
	_box("Sail", Vector3(27, 4.5, -4), Vector3(3, 3, 0.08), Color(0.85, 0.82, 0.72), false)
	for i in range(4):
		_box("Crate%d" % i, Vector3(5 + i * 1.6, 0.5, -17), Vector3(1, 1, 1), Color(0.47, 0.34, 0.22))
	for key in POINTS:
		var p: Vector3 = POINTS[key]["position"]
		_box(key, p + Vector3(0, 0.7, 0), Vector3(0.6, 1.4, 0.6), Color(0.31, 0.40, 0.29))
		var label := Label3D.new()
		label.text = POINTS[key]["label"]
		label.position = p + Vector3(0, 2.3, 0)
		label.font_size = 48
		label.pixel_size = 0.012
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		add_child(label)

func _box(box_name: String, centre: Vector3, size: Vector3, colour: Color, solid: bool = true) -> void:
	var node := Node3D.new()
	node.name = box_name
	node.position = centre
	add_child(node)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = colour
	visual.material_override = material
	node.add_child(visual)
	if solid:
		var body := StaticBody3D.new()
		node.add_child(body)
		var collider := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collider.shape = shape
		body.add_child(collider)
