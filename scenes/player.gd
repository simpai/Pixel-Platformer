extends CharacterBody2D

class_name Player

@export var data : PlayerData
@export var playerId = "1p_"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var airJumpCount:int = 0
var justLanded : bool = false
	
func _ready():
	$AnimatedSprite2D.sprite_frames = data.spriteFrames
	$AnimatedSprite2D.play("Idle")
	

func _physics_process(delta):
	apply_gravity(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(playerId+"left", playerId+"right")
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction > 0
		$AnimatedSprite2D.play("Run")
		velocity.x = move_toward(velocity.x, data.speed * direction, data.moveAccel*delta)
	else:
		$AnimatedSprite2D.play("Idle")
		velocity.x = move_toward(velocity.x, 0, data.moveDecel*delta)
	
	var was_in_air = not is_on_floor()
	move_and_slide()
	justLanded = was_in_air and is_on_floor()
		
	apply_jump()
	
 
func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, data.terminalVelocity, gravity * delta)

func apply_jump():	
	if is_on_floor():
		if justLanded:
			$AnimatedSprite2D.play("Run")
			$AnimatedSprite2D.frame = 1
		airJumpCount = 0
	else:
		$AnimatedSprite2D.play("Jump")

	if Input.is_action_pressed(playerId+"jump"):
		if is_on_floor():
			velocity.y = data.jumpVelocity
		elif velocity.y > 0 and airJumpCount < data.maxAirJump:
			airJumpCount += 1
			velocity.y = data.jumpVelocity

func hit():
	queue_free()
