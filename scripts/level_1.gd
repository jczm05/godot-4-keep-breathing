extends Node2D


func _ready() -> void:
	Global.level = get_tree().current_scene.scene_file_path
	Gui.hide()
	MusicPlayer.play_level1_music()
