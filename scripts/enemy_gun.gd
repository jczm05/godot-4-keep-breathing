extends Node2D
@onready var enemy_gun: Node2D = $"."
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var bullet_spawn: Marker2D = $bullet_spawn
@onready var shoot_timer: Timer = $ShootTimer  # Timer para cooldown

var bullet = preload("res://scenes/bullet.tscn")
@export var fire_rate: float = 1.5
@export var bullet_speed: float = 20.0  # Ajustado para ser más rápido

var owner_enemy: Node2D = null
var can_fire: bool = true

func _ready():
	if not shoot_timer:
		print("ERROR: ShootTimer not found!")
	
	shoot_timer.wait_time = fire_rate
	shoot_timer.timeout.connect(_reset_fire)
	
	if enemy_gun.global_position.x > global_position.x:
		sprite_2d.flip_v = false
	else:
		sprite_2d.flip_v = true

func equip(enemy: Node2D):
	owner_enemy = enemy  # Asigna el enemigo dueño

func aim_at(target_position: Vector2):
	look_at(target_position)

func shoot():
	if not can_fire or not owner_enemy:
		return  # Evita disparos antes de que termine el cooldown
	
	# Verificar si el enemigo tiene un jugador objetivo
	if not owner_enemy.player:
		return

	var player_position = owner_enemy.player.global_position

	can_fire = false
	shoot_timer.start()
	
	if bullet:
		var bullet_instance = bullet.instantiate() as RigidBody2D
		bullet_instance.global_position = bullet_spawn.global_position
		var direction = (player_position - bullet_spawn.global_position).normalized()
		bullet_instance.rotation = direction.angle()
		
		if bullet_instance.has_method("launch"):
			bullet_instance.launch(direction, bullet_speed)
		else:
			bullet_instance.linear_velocity = direction * bullet_speed  # Nueva forma de mover la bala

		# Intentar agregar la bala al BulletLayer
		var bullet_layer = get_tree().current_scene.get_node_or_null("BulletLayer")
		if bullet_layer:
			bullet_layer.add_child(bullet_instance)
		else:
			print("WARNING: BulletLayer not found, adding bullet to root.")
			get_tree().root.add_child(bullet_instance)

		print("Enemy fired a bullet!")

func _reset_fire():
	print("Fire cooldown reset!")
	can_fire = true
