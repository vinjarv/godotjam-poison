extends CharacterBody3D

# Set unit speed and default position.
@export var speed = 225
var click_position = Vector3(0,0,0)

# Set the healh of the infected
var health = 50

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Get where the mouse clicked on the 
func _on_camera_pivot_ground_clicked(mouse_clicked_position):
	print("est")
	click_position =  mouse_clicked_position

func _physics_process(delta):
	# Move the infected to the clicked position
	var click_direction = (click_position - position).normalized()
	var click_length = (click_position - position).length()
	if click_length > 0.8:
		velocity = click_direction * speed * delta
		look_at(click_position)
		set_animation("walking")
	else :
		velocity = Vector3.ZERO
		set_animation("idle")
	
	#print("move towards ", click_direction)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func _ready():
	click_position = position
	$AnimationPlayer.play("idle")
	$AnimationPlayer.speed_scale = 0.5
	$AnimationPlayer.advance(0.3 * randf())
	
func set_animation(name):
	if $AnimationPlayer.current_animation != name:
		$AnimationPlayer.play(name)
		var length = $AnimationPlayer.get_animation(name).length
		print(length)
		$AnimationPlayer.advance(length * randf())
