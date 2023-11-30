extends Area2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

func _on_body_entered(body):
	if body is Player:
		body.get_item()
		collision_mask = 0
		AudioPlayer.play_effect(AudioPlayer.COIN, position)
		animation_player.play("get")
		await animation_player.animation_finished
		
		queue_free()	

