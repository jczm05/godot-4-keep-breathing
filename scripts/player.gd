extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed = 150
var bullet_speed = 900
var bullet = preload("res://scenes/bullet.tscn")
@onready var bullet_spawn: Marker2D = $bullet_spawn

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	play_animations()
	if Input.is_action_just_pressed("shoot"):
		fire()

func play_animations():
	if Input.is_action_pressed("move_left"):
		animated_sprite.play("run_left")
	if Input.is_action_pressed("move_right"):
		animated_sprite.play("run_right")
	if Input.is_action_pressed("move_up"):
		animated_sprite.play("run_up")
	if Input.is_action_pressed("move_down"):
		animated_sprite.play("run_down")
	if !(Input.get_vector("move_left", "move_right", "move_up", "move_down")):
		animated_sprite.play("idle")

func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = bullet_spawn.global_position #global_position + Vector2(16, 16)
	
	# Obtener la dirección hacia el ratón
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Establecer la rotación de la bala
	bullet_instance.rotation = direction.angle()
	
	# Aplicar el impulso en la dirección del ratón
	bullet_instance.apply_impulse(direction * bullet_speed)
	
	# Agregar la bala a la escena
	get_tree().root.call_deferred("add_child", bullet_instance)
