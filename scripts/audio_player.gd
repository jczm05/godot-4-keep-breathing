extends Node

var menu_music = load("res://music/1-MGS3MM.mp3")
var level1_music = load("res://music/2-MGS3LVL.mp3")
var level2_music = load("res://music/3-MGS3LVL2.mp3")

func _ready():
	pass

func play_menu_music():
	#$Music.stream = menu_music
	#$Music.play()
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
