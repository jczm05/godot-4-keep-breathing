extends Control

func _ready() -> void:
	Gui.hide()
	


func _on_exitbttn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
