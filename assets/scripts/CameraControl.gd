extends Node3D

@onready var camera = $Camera

@export var min_zoom_size = 1
@export var max_zoom_size = 100
@export var zoom_speed = 1
@export var move_speed = 1

@export var ground : StaticBody3D 
@export var peasant_parent : Node3D

signal ground_clicked(click_position : Vector3)

var camera_movement = Vector3(0, 0, 0)
var dragging = false
var drag_start_viewport : Vector2
var drag_end_viewport : Vector2

@onready var select_outline = $SelectOverlay

func _ready():
	select_outline.hide()

func _process(delta):
	# Move camera pivot in xz-plane
	# Depends on zoom level
	position += camera_movement * move_speed * camera.size * delta
	if dragging:
		drag_end_viewport = get_viewport().get_mouse_position()
		var size = drag_end_viewport - drag_start_viewport
		# Draw from top left to abs. value of size
		select_outline.position = Vector2(
			min(drag_start_viewport.x, drag_end_viewport.x),
			min(drag_start_viewport.y, drag_end_viewport.y)
		)
		select_outline.size = Vector2(abs(size.x), abs(size.y))
		select_outline.show()
	else:
		select_outline.hide()


func _input(event):
	var zoom_modifier = remap(camera.size, max_zoom_size, min_zoom_size, 20, 1)
	if event.is_action_pressed("zoom_in"):
		camera.size += zoom_speed * zoom_modifier
	if event.is_action_pressed("zoom_out"):
		camera.size -= zoom_speed * zoom_modifier
	camera.size = clamp(camera.size, min_zoom_size, max_zoom_size)
	
	var cam_vec2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera_movement = Vector3(cam_vec2.x, 0, cam_vec2.y)
	
	if event.is_action_pressed("click_right"):
#		var worldspace = get_world_3d().direct_space_state
#		var origin = camera.project_ray_origin(event.position)
#		var end = camera.project_position(event.position, 10000)
#		var raycast_parameters = PhysicsRayQueryParameters3D.create(origin, end)
#		var intersection = worldspace.intersect_ray(raycast_parameters)
#		print(intersection)
#		if intersection["collider"] == ground:
#			var click_position = intersection["position"]
		var world_click_position = get_ground_position(event.position)
		if world_click_position != null:
			emit_signal("ground_clicked", world_click_position)
	
	if event.is_action_pressed("click_left"):
		print("Click")
		dragging = true
		drag_start_viewport = event.position
	if event.is_action_released("click_left"):
		print("Release")
		dragging = false
		var selection_rect = Rect2(select_outline.position, select_outline.size)
		var peasants_selected = []
		for peasant in peasant_parent.get_children():
			var peasant_viewport_position = camera.unproject_position(peasant.position)
			if selection_rect.has_point(peasant_viewport_position):
				peasants_selected.append(peasant)
				peasant.find_child("poison effect").show()
				peasant.find_child("selected_ring").show()
			else:
				peasant.find_child("poison effect").hide()
				peasant.find_child("selected_ring").hide()
		print("Selection: ")
		print(peasants_selected)
		
func get_ground_position(screen_pos : Vector2):
	var worldspace = get_world_3d().direct_space_state
	var origin = camera.project_ray_origin(screen_pos)
	var end = camera.project_position(screen_pos, 10000)
	var raycast_parameters = PhysicsRayQueryParameters3D.create(origin, end, 2)
	var intersection = worldspace.intersect_ray(raycast_parameters)
	var click_position = null
	if intersection["collider"] == ground:
		click_position = intersection["position"]
	return click_position
