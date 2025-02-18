extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed = 150
@onready var gun: Sprite2D = $gun


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	play_animations()
	
		

func play_animations():
	if Input.is_action_pressed("move_left"):
		animated_sprite.play("run_left")
		gun.visible = true
	if Input.is_action_pressed("move_right"):
		animated_sprite.play("run_right")
		gun.visible = true
	if Input.is_action_pressed("move_up"):
		animated_sprite.play("run_up")
		gun.visible = false
	if Input.is_action_pressed("move_down"):
		animated_sprite.play("run_down")
		gun.visible = true
	if !(Input.get_vector("move_left", "move_right", "move_up", "move_down")):
		animated_sprite.play("idle")
		gun.visible = true
