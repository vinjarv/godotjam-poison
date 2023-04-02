extends Node3D

signal spawn_peasant()

# Called when the node enters the scene tree for the first time.
func _ready():
	$house_interface.hide()


func _process(_delta):
	if visible:
		var camera : Camera3D = get_tree().get_root().get_node("World/CameraPivot/Camera")
		var screen_pos = camera.unproject_position(global_position)
		var centre_offset = $house_interface/Panel.size / 2
		$house_interface.position = screen_pos - centre_offset

func _on_exit_button_pressed():
	$house_interface.hide()

func _on_spawn_button_pressed():
	spawn_peasant.emit()
	$house_interface.hide()

