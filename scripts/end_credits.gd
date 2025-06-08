extends Area2D
func _on_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")
		
# Función que se ejecutará después de que el cuerpo haya entrado en el área
func _change_scene():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
