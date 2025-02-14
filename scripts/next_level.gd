extends Area2D

var FILE_PATH = "res://scenes/level_"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")
		
# Función que se ejecutará después de que el cuerpo haya entrado en el área
func _change_scene():
	var next_level_number = get_tree().current_scene.scene_file_path.to_int()+1
	var next_level_path = FILE_PATH + str(next_level_number) + ".tscn"
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)
