class_name CharacterController extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sensitivity = 0.002

func _physics_process(delta):
	velocity.y += -gravity * delta
	move_and_slide()

	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = PlayerData.jump_height / 20

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# move player
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y).normalized()

	if is_on_floor():
		velocity.x = movement_dir.x * PlayerData.speed / 20
		velocity.z = movement_dir.z * PlayerData.speed / 20


	# Rotate the player and the camera
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))

	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Capture the mouse
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_viewport().set_input_as_handled()

		# mine a block
		mine_block()

func mine_block():

	# Cast a ray from the camera to the front
	var ray_length = 5
	var ray_start = $Camera3D.global_transform.origin
	var ray_end = ray_start - $Camera3D.global_transform.basis.z * ray_length


	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, 2)
	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result:
		var block = result.collider.owner

		# Check if the collider is a block
		if block is Block:
			block.mine()

