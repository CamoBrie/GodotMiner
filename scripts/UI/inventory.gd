class_name Inventory extends Control

var res_item = preload("res://scenes/UI/ResourceItemTile.tscn")

func _ready():
	visibility_changed.connect(_update_inventory)

# disable game inputs when inventory is open
func disable_game_inputs(event):
	if event.is_action("move_left"):
		get_viewport().set_input_as_handled()
	elif event.is_action("move_right"):
		get_viewport().set_input_as_handled()
	elif event.is_action("move_forward"):
		get_viewport().set_input_as_handled()
	elif event.is_action("move_back"):
		get_viewport().set_input_as_handled()
	
	
# show/hide inventory
func _input(event):
	if event.is_action_pressed("ui_open") && not visible:
		%Player.velocity.x = 0
		%Player.velocity.z = 0
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		show()
	elif (event.is_action_pressed("ui_open") || event.is_action_pressed("ui_cancel")) && visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hide()
	
	if visible:
		disable_game_inputs(event)
			
# update inventory
func _update_inventory():
	if not visible:
		pass

	# reset display
	for child in $ResourceItems.get_children():
		child.queue_free()
	
	# add resources
	for resource in PlayerData.resources:
		var item = res_item.instantiate()
		item.init(resource, PlayerData.resources[resource])
		$ResourceItems.add_child(item)

