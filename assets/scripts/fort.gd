extends Node3D

@export var enemy_scene : PackedScene
@export var amount_of_troops = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(amount_of_troops):
		spawn_enemy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = get_node("SpawnPath/SpawnLocation")
	enemy_spawn_location.progress_ratio = randf()
	add_child(enemy)
	enemy.global_position = enemy_spawn_location.global_position
	# Look away from fort
	enemy.look_at(global_position, Vector3.UP)
	enemy.rotate(Vector3.UP, PI)
