extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = Vector3(0, randi_range(-20, 20), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
