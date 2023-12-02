extends Area2D

@export var speed = 350
@onready var timer = $Timer

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func setBomb(_position:Vector2, _velocity:Vector2, _time:float):
	position = _position
	velocity = _velocity
	timer.start(_time)
	

func _physics_process(delta):
	velocity += acceleration * delta
	velocity.y += gravity * delta
#	rotation = velocity.angle()
	position += velocity * delta

func _on_body_entered(body):
	queue_free()

func _on_timer_timeout():
	queue_free()
