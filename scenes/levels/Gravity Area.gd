extends Area2D

func _on_body_entered(body):
	if body is Player:
		var player : Player = body
		player.set_in_water(true)
