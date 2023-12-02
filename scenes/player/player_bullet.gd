extends Area2D

@export var damage = 1
var velocity = Vector2.ZERO

func _on_body_entered(body):
	if body is Boss:
		body.hit(damage)
	elif body is HitableEnemy:
		body.hit(damage)
	else:
		queue_free()		
		
func _physics_process(delta):
	position += velocity * delta
	
func setBullet(pos:Vector2, dir:float, speed:float):
	position = pos
	velocity = Vector2(dir*speed, 0)

	

