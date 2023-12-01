extends Panel

@onready var background : Sprite2D = $background
@onready var item : Sprite2D = $CenterContainer/Panel/item
@onready var label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if !slot.item:
		background.frame = 0
		item.visible = false
		label.visible = false
	else:
		background.frame = 1
		item.visible = true
		item.texture = slot.item.texture
		
		if slot.amount == 1:
			label.visible = false
		else:
			label.visible = true
			label.text = str(slot.amount)
		
		
