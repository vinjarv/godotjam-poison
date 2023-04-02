extends CharacterBody3D

# Set unit speed and default position.
@export var speed = 225
var click_position = Vector3(0,0,0)

# Set the healh of the infected and time between health loss
@export var health = 50
@export var time_since_plague_health_loss = 25
var time = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Get where the mouse clicked on the 
func _on_camera_pivot_ground_clicked(mouse_clicked_position):
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
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

# Makes the unit lose health over time
# If this brings the units HP to 0, it dies
func _process(delta):
	time += delta
	if  (time > time_since_plague_health_loss):
		health -= 1
		time = 0
		print("current health: ", health)
	if (health <= 0):
		death()

# Starts the death animation
func death():
	set_animation("death")

# Removes the unit from queue once the death animation is over
func _on_animation_player_animation_finished(death):
	queue_free()

func _ready():
	click_position = position
	$AnimationPlayer.play("idle")
	$AnimationPlayer.speed_scale = 0.5
	$AnimationPlayer.advance(0.3 * randf())
	$RatTimer.wait_time = randf_range(2, 6)
	
func set_animation(name):
	if $AnimationPlayer.current_animation == "death":
		pass
	elif $AnimationPlayer.current_animation != name:
		$AnimationPlayer.play(name)
		var length = $AnimationPlayer.get_animation(name).length
		print(length)
		$AnimationPlayer.advance(length * randf())
	


func _on_rat_timer_timeout():
	$"we are rat we are rats/GPUParticles3D".emitting = true
	$RatTimer.wait_time = randf_range(2, 6)
