extends Control

@onready var continue_b: Button = $Continue
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_b.button_down.connect(on_continue_pressed)

func on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/first_level.tscn")
