extends CharacterBody2D

class_name Player

enum { MOVE, CLIME }

@onready var ladder_check = $LadderCheck
@onready var remote_transform_2d = $RemoteTransform2D

@export var data : PlayerData
@export var playerId = "1p_"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var airJumpCount:int = 0
var state = MOVE

func _ready():
	$AnimatedSprite2D.sprite_frames = data.spriteFrames
	$AnimatedSprite2D.play("Idle")
	
func connect_camera(camera_path:NodePath):
	remote_transform_2d.remote_path = camera_path

func _physics_process(delta):
	var input = Input.get_vector(
		playerId+"left", playerId+"right",
		playerId+"up", playerId+"down")

	match state:
		MOVE: move_state(input, delta)
		CLIME: clime_state(input, delta)
	
	
func is_on_ladder():
	if not ladder_check.is_colliding(): return false
	
	if ladder_check.get_collider() is Ladder: return true

	return false

func clime_state(input:Vector2, _delta):
	if not is_on_ladder():
		state = MOVE

	if input == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.flip_h = input.x > 0
		$AnimatedSprite2D.play("Run")

	velocity = input * data.speed
	move_and_slide()

func move_state(input:Vector2, delta):
	# transition to clime state
	if is_on_ladder() :
		if Input.is_action_pressed(playerId+"up") or velocity.y > 0:  
			state = CLIME
	
	apply_gravity(delta)

	if input.x != 0:
		$AnimatedSprite2D.flip_h = input.x > 0
		$AnimatedSprite2D.play("Run")
		velocity.x = move_toward(velocity.x, data.speed * input.x, data.moveAccel*delta)
	else:
		$AnimatedSprite2D.play("Idle")
		velocity.x = move_toward(velocity.x, 0, data.moveDecel*delta)
	
	var was_in_air = not is_on_floor()
	move_and_slide() #velocity 만큼 움직여줌
	var justLanded = was_in_air and is_on_floor() #공중에 있다가 바닥에 내려옴
		
	if is_on_floor():
		if justLanded:
			$AnimatedSprite2D.play("Run")
			$AnimatedSprite2D.frame = 1
		airJumpCount = 0
	else:
		$AnimatedSprite2D.play("Jump")

	# 점프 키가 눌렸을 때
	if Input.is_action_just_pressed(playerId+"jump"):
		if is_on_floor(): # 바닥에 있다면 무조건 점프
			velocity.y = data.jumpVelocity
			AudioPlayer.play_effect(AudioPlayer.JUMP, position)
		#공중에 있고, 떨어지고 있고, 공중 점프 가능 횟수가 maxAirJump보다 작을 때는 
		elif velocity.y > 0 and airJumpCount < data.maxAirJump: 
			airJumpCount += 1
			velocity.y = data.jumpVelocity
			AudioPlayer.play_effect(AudioPlayer.JUMP, position)


 
func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, data.terminalVelocity, gravity * delta)

func hit():
	AudioPlayer.play_effect(AudioPlayer.HIT, position)
	Events.PlayerDead.emit(playerId)
	queue_free()	
