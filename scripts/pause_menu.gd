extends CanvasLayer

@onready var exit: Button = $VBoxContainer/Exit
@onready var continue_bt: Button = $VBoxContainer/Continue
@onready var exit_mm: Button = $VBoxContainer/Exit_mm
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var save: Button = $VBoxContainer/Save

func _ready() -> void:
	exit.button_down.connect(on_exit_pressed)
	continue_bt.button_down.connect(on_continue_pressed)
	exit_mm.button_down.connect(on_exit_to_main_pressed)
	save.button_down.connect(on_save_pressed)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		animation_player.play()
		$ColorRect.visible = not $ColorRect.visible
		$VBoxContainer.visible = not $VBoxContainer.visible
		

func on_exit_pressed():
	get_tree().quit()

func on_exit_to_main_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func on_continue_pressed():
	get_tree().paused = false
	$ColorRect.visible = false
	$VBoxContainer.visible = false

func on_save_pressed():
	SaveManager.write_save(Global.get_save_data())
