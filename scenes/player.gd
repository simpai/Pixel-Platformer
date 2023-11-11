extends CharacterBody2D

@export var Speed : float = 100
@export var JumpVelocity : float = -250.0
@export var maxAirJump : int = 2

var airJumpCount:int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var moveAccel = 200
var moveDecel = 100


func _physics_process(delta):
	apply_gravity(delta)
	apply_air_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, Speed * direction, moveAccel*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, moveDecel*delta)

	move_and_slide()
 
func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: 
			velocity.y += gravity * delta # 떨어질 때 
		else:			
			velocity.y += gravity * delta # 올라갈 때 

##살짝 점프
#func apply_weak_jump(): 
#	if is_on_floor():	# Handle Jump.
#		if Input.is_action_just_pressed("ui_accept"):
#			velocity.y = JumpVelocity
#	else:
#		if Input.is_action_just_released("ui_accept") and velocity.y < -50:
#			velocity.y = -50
	
#공중 점프	
func apply_air_jump():	
	if is_on_floor():
		airJumpCount = 0

	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JumpVelocity
		elif velocity.y > 0 and airJumpCount < maxAirJump:
			airJumpCount += 1
			velocity.y = JumpVelocity
