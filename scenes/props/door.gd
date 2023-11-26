extends Area2D

@export_file("*.tscn") var move_to_scene : String




func _on_body_entered(body):
	if not body is Player: return
	if move_to_scene.is_empty(): return
	
	get_tree().change_scene_to_file(move_to_scene)
	

