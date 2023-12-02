extends Node2D

var player1:Player
var player2:Player

@onready var user_panel_1 = $CanvasLayer/user_panel1
@onready var user_panel_2 = $CanvasLayer/user_panel2

# 플래이어 스폰 포지션
var player_spawn_pos1:Vector2 
var player_spawn_pos2:Vector2

@onready var camera = $PlayerCenter/Camera
@onready var player_center = $PlayerCenter
@onready var camera_2d = $PlayerCenter/Camera/Camera2D

const player_scene = preload("res://scenes/player/player.tscn")
const player1_data = preload("res://resources/player_data/YellowPlayer.tres")
const player2_data = preload("res://resources/player_data/PinkPlayer.tres")

# Called when the node enters the scene tree for the first time.
func _ready():#배경화면
	RenderingServer.set_default_clear_color(Color.DODGER_BLUE)
	Events.PlayerDead.connect(on_player_dead)
	Events.PlayerCheckPoint.connect(on_player_check_point)
	Events.PlayerHit.connect(on_player_health)
	Events.GetCoin.connect(on_get_coin)
	
	var startPos:String = Transitions.finish_transition()
	
	if startPos.is_empty():
		player_spawn_pos1 = $Start1P.global_position
		player_spawn_pos2 = $Start2P.global_position
	else:
		player_spawn_pos1 = get_node("Portals/"+startPos).global_position
		player_spawn_pos2 = get_node("Portals/"+startPos).global_position
	
	create_player1()	
	create_player2()
	
	active_player2()
	
func on_player_health(id:String):
	if id == "1p_":
		user_panel_1.updateHearts(player1.health)
	elif id == "2p_":
		user_panel_2.updateHearts(player2.health)
	
func on_get_coin(id:String):
	if id == "1p_":
		user_panel_1.setCoin(player1.coin)
	elif id == "2p_":
		user_panel_2.setCoin(player2.coin)


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
	player1.set_in_water(false)
	user_panel_1.setMaxHearts(player1.maxHealth)
	user_panel_1.updateHearts(player1.health)
	user_panel_1.setCoin(0)


func create_player2():
	player2 = player_scene.instantiate()
	player2.data = player2_data
	player2.playerId = "2p_"
	add_child(player2)
	player2.global_position = player_spawn_pos2
	player2.name = "player2"	
	player2.set_in_water(false)
	user_panel_2.setMaxHearts(player2.maxHealth)
	user_panel_2.updateHearts(player2.health)
	user_panel_2.setCoin(0)

func active_player1():
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
		await get_tree().create_timer(2).timeout
		create_player1()
	elif id == "2p_":
		active_player1()
		await get_tree().create_timer(2).timeout
		create_player2()
	
var cameraZoomTarget = 1
var cameraTarget:Vector2

func _process(_delta):
	if Input.is_action_just_pressed("1p_camera"):
		active_player1()
	if Input.is_action_just_pressed("2p_camera"):
		active_player2()
		
	
#	if player1 == null && player2 == null:
#		cameraZoomTarget = 1
#		pass
#	elif player1 == null:
#		cameraTarget = player2.position
#		cameraZoomTarget = 1
#	elif player2 == null:
#		cameraTarget = player1.position
#		cameraZoomTarget = 1
#	else:
#		cameraTarget = (player1.position + player2.position)/2
#		var baseDistance = 200
#		var distance = abs(player1.position.x - player2.position.x)
#		if  distance > baseDistance:
#			cameraZoomTarget = baseDistance/distance
#		else:
#			cameraZoomTarget = 1
#
#
#	var x = move_toward(player_center.position.x, cameraTarget.x, 500 *_delta)
#	var y = move_toward(player_center.position.y, cameraTarget.y, 500 *_delta)
#	player_center.position = Vector2(x,y)
#	camera_2d.zoom = Vector2.ONE * move_toward(camera_2d.zoom.x, cameraZoomTarget, 1*_delta)


