class_name Block extends Node3D

var _max_health : float
var _health : float : 
	set (value): 
		_health = value
		if _health != _max_health:
			$Health_Label.show()
		$Health_Label.text = str(_health) + " / " + str(_max_health)
		if $Health_Label/Timer.is_inside_tree():
			$Health_Label/Timer.start()

var loot_table : Array[LootItem] = []

signal block_destroyed

# initialize the block
func init(bsd : BlockSpawnData):
	set_health(bsd.health)
	$StaticBody3D/Mesh.mesh = $StaticBody3D/Mesh.mesh.duplicate()
	$StaticBody3D/Mesh.mesh.material = bsd.material
	loot_table = bsd.loot_table
	$Health_Label/Timer.timeout.connect(_on_label_timer)

# sets health
func set_health(health):
	_max_health = health
	_health = health

# reset label
func _on_label_timer():
	$Health_Label.hide()
	$Health_Label/Timer.stop()

# hit the block once
func mine():
	_health -= PlayerData.damage / 100

	if _health <= 0:
		get_loot()
		destroy_block()

# get loot
func get_loot():
	var loot : Array[LootItem] = []

	# get weights
	var total_weight = 0
	for loot_item in loot_table:
		total_weight += loot_item.weight
	
	# get number of rolls
	var rolls = (randi() % (PlayerData.max_roll - PlayerData.min_roll + 1)) + PlayerData.min_roll

	# roll for loot
	for i in range(rolls):
		roll_loot(loot, total_weight)

	# add loot to player
	for loot_item in loot:
		var amount = (randi() % (loot_item.max_roll - loot_item.min_roll + 1)) + loot_item.min_roll

		if PlayerData.resources.has(loot_item.resource):
			PlayerData.resources[loot_item.resource] += amount
		else:
			PlayerData.resources[loot_item.resource] = amount

# roll for loot
func roll_loot(loot, total_weight):
	var roll = randi() % total_weight
	for loot_item in loot_table:
		roll -= loot_item.weight
		if roll <= 0:
			loot.append(loot_item)
			break
	

# destroy the block
func destroy_block():
	block_destroyed.emit()
	queue_free()
