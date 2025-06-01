extends Control

@onready var back: Button = $Back
@onready var clicksound: AudioStreamPlayer = $clicksound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back.button_down.connect(on_back_pressed)

func on_back_pressed() -> void:
	clicksound.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
