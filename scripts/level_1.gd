extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gui.hide()
	MusicPlayer.play_level1_music()
