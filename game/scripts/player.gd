extends CharacterBody3D
## Small third-person controller. Movement, camera and gravity only.

@export var walking_speed: float = 4.0
@export var running_speed: float = 6.0
@onready var pivot: Node3D = $CameraPivot
@onready var arm: SpringArm3D = $CameraPivot/SpringArm3D

func _ready() -> void:
	arm.add_excluded_object(get_rid())
	if DisplayServer.get_name() != "headless":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y = wrapf(rotation.y - event.relative.x * 0.003, -PI, PI)
		pivot.rotation.x = clampf(pivot.rotation.x - event.relative.y * 0.003, -0.8, 0.25)

func _physics_process(delta: float) -> void:
	var axis := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := global_transform.basis * Vector3(axis.x, 0.0, axis.y)
	var speed: float = running_speed if Input.is_action_pressed("run") else walking_speed
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0.0
	move_and_slide()
	# A prototype boundary, not a coastline or swimming mechanic.
	position.x = clampf(position.x, -23.0, 16.0)
	position.z = clampf(position.z, -23.0, 18.0)
	if position.y < -5.0:
		position = Vector3(0, 0.1, 6)
		velocity = Vector3.ZERO
