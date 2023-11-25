extends Node2D

@onready var ray_cast_2d = $RayCast2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var gpu_particles_2d = $GPUParticles2D

@export var fall_speed : float = 180
@export var rise_speed : float = 30

enum STATE { NONE, HOVER, FALL, LAND, RISE }

var state : STATE = STATE.NONE

var start_position:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = global_position
	hover_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		STATE.HOVER: hover_state(delta)
		STATE.FALL: fall_state(delta)
		STATE.LAND: land_state(delta)
		STATE.RISE: rise_state(delta)


func hover_start():
	animation_player.play("idle")
	state = STATE.HOVER
	timer.start(0.13)

func fall_start():
	state = STATE.FALL
	animation_player.play("fall")

func land_start():
	gpu_particles_2d.emitting = true
	animation_player.play("idle")
	state = STATE.LAND
	timer.start(0.1)

func rise_start():
	state = STATE.RISE
	animation_player.play("up")
	

func hover_state(delta):
	if timer.time_left == 0:
		fall_start()
	
func fall_state(delta):
	position.y += fall_speed * delta
	
	if ray_cast_2d.is_colliding():
		position.y = ray_cast_2d.get_collision_point().y
		land_start()
	
func land_state(delta):
	if timer.time_left == 0:
		rise_start()
	
func rise_state(delta):
	position.y -= rise_speed * delta
	if global_position.y <= start_position.y:
		global_position.y = start_position.y
		hover_start()
			
