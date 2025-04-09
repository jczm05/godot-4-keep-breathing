extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Sprite2D = $gun
@onready var timer: Timer = $Timer
@onready var health = Gui.get_node_or_null("health_bar")  # Evita errores si no existe
var bullet = preload("res://scenes/bullet.tscn")

@export var speed = 150

func _ready():
	progress_bar.set_value_no_signal(Global.life)
	if health == null:
		print_debug("Health no")

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	play_animations()
	Global.life = progress_bar.value

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

func take_damage():
	progress_bar.set_value_no_signal(progress_bar.value - 33)  # Restar vida
	print("¡Me han disparado! Vida restante: ", progress_bar.value)

	if progress_bar.value <= 66 and progress_bar.value > 33:
		health.play("2")  # Segunda fase de daño
	elif progress_bar.value <= 33 and progress_bar.value > 0:
		health.play("1")  # Última fase antes de morir
	elif progress_bar.value <= 0:  # Si la vida llega a 0, el jugador muere
		health.play("3")
		animated_sprite.play("death")
		await get_tree().create_timer(0.5).timeout  # Espera antes de eliminar al jugador
		queue_free()
		get_tree().reload_current_scene()  # Reiniciar nivel

func _on_bullet_hit(body):
	if body.has_method("take_damage"):  # Asegurar que el objeto puede recibir daño
		body.take_damage()
