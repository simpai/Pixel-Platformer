extends Path2D
@onready var path_follow_2d = $PathFollow2D

@export var speed = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _physics_process(delta):
#	var cur = path_follow_2d.progress_ratio
#	cur = cur + delta * speed
#	path_follow_2d.progress_ratio = cur

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
