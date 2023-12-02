extends CharacterBody2D

enum STATE { NONE, MOVE, JUMP, ATTACK }
var state : STATE = STATE.NONE

const bombScene = preload("res://scenes/enemies/spike_bomb.tscn")
@onready var animation_player = $AnimationPlayer

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var moveTime:float = 0
var moveLeft:bool = true

func get_random_move_time():
	return randf_range(1,4)

func _ready():
	move_start(get_random_move_time(), true)


func _physics_process(delta):
	move_state(delta)

func move_start(move_time:float, left:bool):
	state = STATE.MOVE
	moveTime = move_time
	moveLeft = left
	animation_player.play("walking")

func move_state(delta):
	moveTime -= delta
	if moveTime <= 0:
		move_start(get_random_move_time(), !moveLeft)
	
	if moveLeft:
		velocity.x = -SPEED
	else:
		velocity.x = SPEED

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

var attacking = false
func _on_jump_timer_timeout():
	if attacking == false:
		velocity.y = -500
		animation_player.play("jump")
		await animation_player.animation_finished
	animation_player.play("walking")


func _on_attack_timer_timeout():
	attacking = true
	animation_player.play("spike")
	await animation_player.animation_finished
	attacking = false
	animation_player.play("walking")
	
	for i in range(6):
		var force = randf_range(400,500)
		var _velocity = Vector2(-force, 0).rotated(deg_to_rad(i*30))
		var bomb = bombScene.instantiate()
		get_parent().add_child(bomb)
		bomb.setBomb(position, _velocity, 3)
