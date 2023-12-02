extends CharacterBody2D

class_name Boss

enum STATE { NONE, MOVE, JUMP, ATTACK }
var state : STATE = STATE.NONE
var health = 100

const bombScene = preload("res://scenes/enemies/boss_bullet.tscn")
@onready var animation_player = $AnimationPlayer
@onready var animation_player_hit = $AnimationPlayerHit

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var moveTime:float = 0
var moveLeft:bool = true

func get_random_move_time():
	return randf_range(1,2)

func _ready():
	move_start(true)


func _physics_process(delta):
	if health <= 0:
		return
		
	match state:
		STATE.MOVE: move_state(delta)
		STATE.JUMP: jump_state(delta)
		STATE.ATTACK: attack_state(delta)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
		
func move_start(left:bool):
	state = STATE.MOVE
	moveTime = get_random_move_time()
	moveLeft = left
	animation_player.play("walking")

func jump_start():
	state = STATE.JUMP
	animation_player.play("jump")
	velocity.y = -500
	velocity.x *= 3

func attack_start():
	state = STATE.ATTACK
	velocity.x = 0
	animation_player.play("spike")
	
func move_state(delta):
	moveTime -= delta
	if moveTime <= 0:
		move_start(moveLeft)
	
	if moveLeft:
		velocity.x = -SPEED
	else:
		velocity.x = SPEED


func jump_state(delta):
	if is_on_floor():
		move_start(!moveLeft)
	
func attack_state(_delta):
	if animation_player.is_playing() == false:
		for i in range(9):
			var force = randf_range(400,500)
			var _velocity = Vector2(-force, 0).rotated(deg_to_rad(i*20))
			var bomb = bombScene.instantiate()
			get_parent().add_child(bomb)
			bomb.setBomb(position, _velocity, 3)
		move_start(!moveLeft)
		
func _on_ai_timer_timeout():
	select_action()
		
func select_action():
	match randi_range(0,4):
		0: move_start(!moveLeft)
		1: attack_start()
		2: attack_start()
		3: attack_start()
		4: jump_start()

func hit(damage : int):
	AudioPlayer.play_effect(AudioPlayer.HIT, position)
	health -= damage

	if health <= 0:
		animation_player_hit.play("die")
		await animation_player_hit.animation_finished
		queue_free()
	else:
		animation_player_hit.play("hit")
