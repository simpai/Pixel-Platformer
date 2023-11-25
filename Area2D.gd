extends Area2D




func _on_body_entered(body):
	var player: Player = body
	if body == null: return
	Events.PlayerCheckPoint.emit(player.playerId, global_position)
