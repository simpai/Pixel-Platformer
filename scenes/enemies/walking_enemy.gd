extends CharacterBody2D

class_name HitableEnemy

@export var speed : float = 30
@onready var ledgeCheckL = $RayCast2DL
@onready var ledgeCheckR = $RayCast2DR
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var animation_player_hit = $AnimationPlayerHit

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var xDirection : float = -1

func _ready():
	animation_player.play("Walking")

func _physics_process(_delta):
	var found_legde = not ledgeCheckL.is_colliding() or not ledgeCheckR.is_colliding()

	if is_on_wall() or found_legde:
		xDirection *= -1
		
	sprite_2d.flip_h = xDirection > 0

	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta

	velocity.x = xDirection * speed
	move_and_slide()

var health = 1
func hit(damage : int):
	AudioPlayer.play_effect(AudioPlayer.HIT, position)
	health -= damage

	if health <= 0:
		animation_player_hit.play("die")
		await animation_player_hit.animation_finished
		queue_free()
	else:
		animation_player_hit.play("hit")

