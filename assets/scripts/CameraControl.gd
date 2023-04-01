extends Node3D

@onready var camera = $Camera

@export var min_zoom_size = 1
@export var max_zoom_size = 100
@export var zoom_speed = 1
@export var move_speed = 1

var camera_movement = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move camera pivot in xz-plane
	# Depends on zoom level
	position += camera_movement * move_speed * camera.size * delta 

func _input(event):
	
	
	if event.is_action_pressed("zoom_in"):
		camera.size += zoom_speed
	if event.is_action_pressed("zoom_out"):
		camera.size -= zoom_speed
	camera.size = clamp(camera.size, min_zoom_size, max_zoom_size)
	
	var cam_vec2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera_movement = Vector3(cam_vec2.x, 0, cam_vec2.y)
	
