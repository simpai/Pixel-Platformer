extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.hit()
		#get_tree().reload_current_scene()
