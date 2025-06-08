extends Node2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	Global.level = get_tree().current_scene.scene_file_path


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_4.tscn")
