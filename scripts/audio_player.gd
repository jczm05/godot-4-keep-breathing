extends Node

var menu_music = load("res://music/soliloquy.mp3")
var level1_music = load("res://music/wasteland_overdrive_looped.wav")
var level2_music = load("res://music/fall_of_arcana_new_era_looped.wav")

func _ready():
	$Music.connect("finished", Callable(self, "_on_Music_finished"))

func play_menu_music():
	if $Music.stream == menu_music:
		return
	$Music.stream = menu_music
	$Music.play()

func play_level1_music():
	if $Music.stream == level1_music:
		return
	$Music.stream = level1_music
	$Music.play()

func play_level2_music():
	if $Music.stream == level2_music:
		return
	$Music.stream = level2_music
	$Music.play()

func _on_Music_finished():
	$Music.play()
