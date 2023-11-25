extends Node2D

var player1:Player
var player2:Player

var player_spawn_pos1:Vector2
var player_spawn_pos2:Vector2

@onready var camera = $Camera

const player_scene = preload("res://scenes/player.tscn")
const player1_data = preload("res://resources/player_data/YellowPlayer.tres")
const player2_data = preload("res://resources/player_data/PinkPlayer.tres")
@onready var moving_spike_enemy = $MovingSpikeEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.DODGER_BLUE)
	Events.PlayerDead.connect(on_player_dead)
	Events.PlayerCheckPoint.connect(on_player_check_point)
	
	player_spawn_pos1 = $Start1P.global_position
	player_spawn_pos2 = $Start2P.global_position
	
	create_player1()
	create_player2()
	
	active_player2()

func on_player_check_point(id:String, pos:Vector2):
	if id == "1p_":
		player_spawn_pos1 = pos
	elif id == "2p_":
		player_spawn_pos2 = pos
		
func create_player1():
	player1 = player_scene.instantiate()
	player1.data = player1_data
	player1.playerId = "1p_"
	add_child(player1)
	player1.global_position = player_spawn_pos1
	player1.name = "player1"

func create_player2():
	player2 = player_scene.instantiate()
	player2.data = player2_data
	player2.playerId = "2p_"
	add_child(player2)
	player2.global_position = player_spawn_pos2
	player2.name = "player2"

func active_player1():
	print(camera.get_path())
	if player1 != null:
		player1.connect_camera(camera.get_path())
	if player2 != null:
		player2.connect_camera(NodePath())

func active_player2():
	if player1 != null:
		player1.connect_camera(NodePath())
	if player2 != null:
		player2.connect_camera(camera.get_path())

	
func on_player_dead(id:String):
	if id == "1p_":
		active_player2()
	elif id == "2p_":
		active_player1()
	
func _process(_delta):
	if Input.is_action_just_pressed("1p_camera"):
		active_player1()
	if Input.is_action_just_pressed("2p_camera"):
		active_player2()
		
	if player1 == null && Input.is_action_just_pressed("1p_jump"):
		create_player1()

	if player2 == null && Input.is_action_just_pressed("2p_jump"):
		create_player2()



