extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func play_exit_transition():
	animation_player.play("ExitLevel")
	await animation_player.animation_finished

func play_enter_transition():
	animation_player.play("EnterLevel")







