class_name Inventory extends Control

func _ready():
	visibility_changed.connect(_update_inventory)


func _input(event):
	if event.is_action_pressed("ui_open") && not visible:
		%Player.velocity.x = 0
		%Player.velocity.z = 0
		show()
	elif event.is_action_pressed("ui_open") && visible:
		hide()

	if visible:
		get_viewport().set_input_as_handled()


func _update_inventory():
	if not visible:
		pass

	var text_str = "Inventory:\n"
	for resource in PlayerData.resources:
		text_str += resource + ": " + str(PlayerData.resources[resource]) + "\n"
	
	$InventoryText.text = text_str

