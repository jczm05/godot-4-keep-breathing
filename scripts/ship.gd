extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 300


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	play_animations()

func play_animations():
	if Input.is_action_pressed("move_left"):
		animated_sprite.flip_h = true
		animated_sprite.play("move_idle")
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_up"):
		animated_sprite.flip_h = true
		animated_sprite.play("up_down")
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_down"):
		animated_sprite.flip_h = true
		animated_sprite.play("up_down")
	if Input.is_action_pressed("move_right"):
		animated_sprite.flip_h = false
		animated_sprite.play("move_idle")
	if !(Input.get_vector("move_left", "move_right", "move_up", "move_down")):
		animated_sprite.play("move_idle")
