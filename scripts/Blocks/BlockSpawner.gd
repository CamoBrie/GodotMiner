class_name BlockSpawner extends Marker3D

var timer : Timer
var block_scene = preload("res://scenes/block.tscn")
@export var block_spawn_data : BlockSpawnData

func _ready():
  timer = $BlockTimer
  timer.timeout.connect(on_block_timer)
  spawn_block(block_spawn_data)

func spawn_block(bsd : BlockSpawnData):
  # Spawn a block
  var block : Block = block_scene.instantiate()
  block.init(bsd)
  block.block_destroyed.connect(on_block_destroyed)

  # Add to scene
  add_child(block)
  block.global_transform.origin = global_transform.origin + block.transform.origin

func on_block_destroyed():
  # Respawn the block after a delay
  timer.wait_time = PlayerData.block_spawn / 100.0
  timer.start()

func on_block_timer():
  spawn_block(block_spawn_data)
  timer.stop()
 
