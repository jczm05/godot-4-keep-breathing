extends Control
var loaded_data
@onready var health: AnimatedSprite2D = $health_bar
@onready var lvl: Label = $LVL
@onready var kfound: Label = $KFOUND
@onready var _current_ammo_label: Label = $_current_ammo_label
@onready var _ammo_reserves_label: Label = $_ammo_reserves_label
var k_str
var lvl_text
@onready var continue_button: Button = $Continue
var life
@onready var exit: Button = $Exit
@onready var clicksound: AudioStreamPlayer = $clicksound
@onready var startsound: AudioStreamPlayer = $startsound

func _ready() -> void:
	loaded_data = SaveManager.read_save()
	if loaded_data is Dictionary:
		Global.load_from_data(loaded_data)
	health_animation()
	lvl_text = loaded_data.get("level")
	lvl.text = lvl_text.substr(13, lvl_text.length()-5)
	k_str = str(loaded_data.get("key_founded"))
	kfound.text = k_str.substr(1, k_str.length()-2)
	_current_ammo_label.text = str(int(loaded_data.get("ammo")))
	_ammo_reserves_label.text = str(int(loaded_data.get("reserve_ammo")))
	continue_button.button_down.connect(on_continue_pressed)
	exit.button_down.connect(on_exit_pressed)

func on_continue_pressed() -> void:
	startsound.play()
	get_tree().change_scene_to_file(loaded_data.get("level"))

func on_exit_pressed():
	clicksound.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func health_animation():
	if loaded_data.get("life") <= 66 and loaded_data.get("life") > 33:
		health.play("1")
	elif loaded_data.get("life") <= 33 and loaded_data.get("life") > 0:
		health.play("2")
	elif loaded_data.get("life") <= 0:
		health.play("3")
	else:
		health.play("0")
