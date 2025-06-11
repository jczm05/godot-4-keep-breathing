extends Control

@onready var start_game: Button = $VBoxContainer/Start_Game
@onready var continue_button: Button = $VBoxContainer/Continue
@onready var options: Button = $VBoxContainer/Options
@onready var exit: Button = $VBoxContainer/Exit
@onready var clicksound: AudioStreamPlayer = $clicksound
@onready var startsound: AudioStreamPlayer = $startsound

func _ready() -> void:
	Gui.hide()
	MusicPlayer.play_menu_music()
	start_game.button_down.connect(on_start_pressed)
	exit.button_down.connect(on_exit_pressed)
	options.button_down.connect(on_options_pressed)
	continue_button.button_down.connect(on_continue_pressed)

func on_continue_pressed() -> void:
	clicksound.play()
	var path = "user://savegame.json"
	if FileAccess.file_exists(path):
		get_tree().change_scene_to_file("res://scenes/load_screen.tscn")
		

func on_options_pressed() -> void:
	clicksound.play()
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func on_start_pressed() -> void:
	startsound.play()
	get_tree().change_scene_to_file("res://scenes/story_intro.tscn")
	

func on_exit_pressed() -> void:
	clicksound.play()
	get_tree().quit()
