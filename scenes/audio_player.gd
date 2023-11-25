extends Node

@onready var bgm = $Music/BGM
@onready var effects = $Effects

const COIN = preload("res://sound/coin.wav")
const HIT = preload("res://sound/damage.wav")
const JUMP = preload("res://sound/jump.wav")
const LOSE = preload("res://sound/lose.wav")

const BGM1 = preload("res://sound/bgm.mp3")


func play_effect(stream, position:Vector2):
	for effect in effects.get_children():
		if effect.stream == null:
			effect.stream = stream
			effect.position = position 
			effect.play()
			break
		elif effect.stream == stream:
			effect.position = position 
			effect.play()
			break	

func play_music(stream):
	bgm.stream = stream
	bgm.play()
