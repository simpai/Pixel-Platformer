#@tool
extends Path2D

enum ANIMATION_TYPE 
{
	BOUNCE,
	LOOP
}

@export var speed:float = 1#: set = _set_speed, get = _get_speed
@export var animation_type:ANIMATION_TYPE = ANIMATION_TYPE.LOOP#: set = _set_animation, get = _get_animation
@onready var animation_player = $AnimationPlayer

#func _set_speed(value):
#	speed = value
#	play_animation()
#
#func _get_speed():
#	return speed
#
#func _set_animation(value):
#	animation_type = value
#	play_animation()
#
#func _get_animation():
#	return animation_type
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	play_animation()
	
func play_animation():
	animation_player.speed_scale = speed
	match(animation_type):
		ANIMATION_TYPE.BOUNCE: animation_player.play("move_bounce")
		ANIMATION_TYPE.LOOP: animation_player.play("move_loop")
	
