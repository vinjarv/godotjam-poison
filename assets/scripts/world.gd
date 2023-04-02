extends Node3D

var game_win_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello World")
	$CameraPivot/VictoryScreen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $fort/Troops.get_child_count() == 0 && game_win_state == false :
		$CameraPivot/VictoryScreen.show()
		game_win_state = true


func _on_button_pressed():
	get_tree().quit()


func _on_button_2_pressed():
	get_tree().reload_current_scene()
