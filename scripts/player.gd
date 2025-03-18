extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Sprite2D = $gun
@onready var timer: Timer = $Timer
@onready var health = Gui.get_node_or_null("health_bar")  # Evita errores si no existe
var bullet = preload("res://scenes/bullet.tscn")

@export var speed = 150
var damage_count = 0

func _ready():
	var bullet_instance = bullet.instantiate()
	bullet_instance.connect("hit", _on_bullet_hit)

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
	elif Input.is_action_pressed("move_right"):
		animated_sprite.play("run_right")
		gun.visible = true
	elif Input.is_action_pressed("move_up"):
		animated_sprite.play("run_up")
		gun.visible = false
	elif Input.is_action_pressed("move_down"):
		animated_sprite.play("run_down")
		gun.visible = true
	else:
		animated_sprite.play("idle")
		gun.visible = true

func take_damage(count: int):
	print("¡Me han disparado! Vida restante: ", 3 - count)  # Debugging mejorado
	damage_count += 1
	health.play(str(count))

	if count > 2:
		animated_sprite.play("death")
		await get_tree().create_timer(0.5).timeout  # En lugar de ralentizar el juego
		queue_free()
		get_tree().reload_current_scene()  # Reiniciar nivel

func _on_bullet_hit(body):
	if body == self:
		take_damage(damage_count)
