extends Node3D

@export var character_scene: PackedScene
@onready var character_basic = preload("res://assets/scenes/basic_infected_script.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_new_infected():
	# character_basic for the pre-loaded one, or character_scene for the modular one in editor
	var character = character_basic.instantiate()
	var character_spawn_location = get_node("SpawnPath/SpawnLocation")
	character_spawn_location.progress_ratio = randf()
	get_tree().get_root().get_node("World/Peasants").add_child(character)
	character.global_position = character_spawn_location.global_position
	character.click_position = character.position
	print("Unit spawned!")
	
