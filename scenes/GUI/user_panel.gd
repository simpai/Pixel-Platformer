extends VBoxContainer

@export var test = 0

@onready var heart_container = $heartContainer
@onready var heartGuiClass = preload("res://scenes/GUI/heart.tscn");
@onready var label = $HBoxContainer/Label

func _ready():
	pass

func setCoin(coin:int):
	label.text = "x " + str(coin)
			
func setMaxHearts(max:int):
	for i in range(max):
		if heart_container.get_child_count() <= i:
			var heart = heartGuiClass.instantiate()
			heart_container.add_child(heart)

func updateHearts(currentHealth:int):
	var hearts = heart_container.get_children()

	for i in range(hearts.size()):
		if i < currentHealth:
			hearts[i].update(true)
		else:
			hearts[i].update(false)
	
