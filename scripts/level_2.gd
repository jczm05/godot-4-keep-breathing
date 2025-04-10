extends Node2D


func _ready() -> void:
	Global.level = get_tree().current_scene.scene_file_path
	Gui.show()
	MusicPlayer.play_level2_music()
