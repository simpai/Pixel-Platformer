extends Area2D

@export var damage = 1

func _on_body_entered(body):
	print(body)
	if body is Player:
		body.hit(damage)
	elif body is Boss:
		body.hit(damage)
	elif body is HitableEnemy:
		body.hit(damage)
		
		
