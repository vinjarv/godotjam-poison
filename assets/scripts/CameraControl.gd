extends Node3D

@onready var camera = $Camera

@export var min_zoom_size = 1
@export var max_zoom_size = 100
@export var zoom_speed = 1
@export var move_speed = 1

@export var ground : StaticBody3D 

signal ground_clicked(click_position : Vector3)

var camera_movement = Vector3(0, 0, 0)

func _ready():
	pass # Replace with function body.


func _process(delta):
	# Move camera pivot in xz-plane
	# Depends on zoom level
	position += camera_movement * move_speed * camera.size * delta 

func _input(event):
	var zoom_modifier = remap(camera.size, max_zoom_size, min_zoom_size, 20, 1)
	if event.is_action_pressed("zoom_in"):
		camera.size += zoom_speed * zoom_modifier
	if event.is_action_pressed("zoom_out"):
		camera.size -= zoom_speed * zoom_modifier
	camera.size = clamp(camera.size, min_zoom_size, max_zoom_size)
	
	var cam_vec2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera_movement = Vector3(cam_vec2.x, 0, cam_vec2.y)
	
	if event.is_action_pressed("click_left"):
		var worldspace = get_world_3d().direct_space_state
		var origin = camera.project_ray_origin(event.position)
		var end = camera.project_position(event.position, 10000)
		var raycast_parameters = PhysicsRayQueryParameters3D.create(origin, end)
		var intersection = worldspace.intersect_ray(raycast_parameters)
		print(intersection)
		if intersection["collider"] == ground:
			var click_position = intersection["position"]
			emit_signal("ground_clicked", click_position)
