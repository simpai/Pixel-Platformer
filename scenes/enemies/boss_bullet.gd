extends Area2D

@export var damage = 1
@onready var timer = $Timer

var velocity = Vector2.ZERO

func _on_body_entered(body):
	if body is Player:
		body.hit(damage)
		
func _physics_process(delta):
	velocity.y += gravity * delta
	position += velocity * delta

func setBomb(_position:Vector2, _velocity:Vector2, _time:float):
	position = _position
	velocity = _velocity
	timer.start(_time)

func _on_timer_timeout():
	queue_free()
