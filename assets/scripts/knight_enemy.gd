extends CharacterBody3D

# Set unit speed and default position.
@export var speed = 100
var click_position = Vector3(0,0,0)

# Set the healh of the knight
@export var health = 100

# The attack power of the knight
@export var attack_power = 25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _on_attack_delay_timeout():
	enable_collision_layer()

# If the unit collides with a hostile, it gathers the attack power of that unit
func _on_hostile_detector_body_entered(body):
	var hostile_attack_power = body.attack_power
	body.attack_cooldown
	print(hostile_attack_power)
	take_damage(hostile_attack_power)
	$attackDelay.start()

func attack_cooldown():
	disable_collision_layer()

# Makes the unit take damage equal to the attackers power
# If this brings the unitts HP to 0 or less, it dies
func take_damage(hostile_attack_power):
	var new_health = health - hostile_attack_power
	health = new_health
	if (health <= 0):
		death()
	$DamageAnimation.play("Damage")
	$DamageAnimation.seek(0)

# Starts the death animation
func death():
	set_animation("death")

# Removes the unit from queue once the death animation is over
func _on_animation_player_animation_finished(death):
	queue_free()

func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.speed_scale = 0.5
	$AnimationPlayer.advance(0.3 * randf())


func set_animation(name):
	if $AnimationPlayer.current_animation == "death":
		pass
	elif $AnimationPlayer.current_animation != name:
		$AnimationPlayer.play(name)
		var length = $AnimationPlayer.get_animation(name).length
		$AnimationPlayer.advance(length * randf())

func disable_collision_layer():
	collision_layer &=~ 4

func enable_collision_layer():
	collision_layer |= 4
