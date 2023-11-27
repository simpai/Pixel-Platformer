extends CanvasLayer

@onready var animation_player = $AnimationPlayer
var startPos:String = ""

func start_transition(_startPos:String):
	startPos = _startPos
	animation_player.play("ExitLevel")
	await animation_player.animation_finished

func finish_transition():
	animation_player.play("EnterLevel")
	return startPos
		







