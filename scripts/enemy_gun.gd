extends Node2D

@onready var bullet_spawn: Marker2D = $bullet_spawn

var bullet = preload("res://scenes/bullet.tscn")
@export var fire_rate: float = 1.5  # Segundos entre disparos
@export var bullet_speed: float = 10.0

@onready var shoot_timer = $ShootTimer  # Timer en el arma

var owner_enemy: Node2D = null  # El enemigo que usa esta arma
var can_fire: bool = true

func _ready():
	shoot_timer.wait_time = fire_rate
	shoot_timer.timeout.connect(_reset_fire)

func equip(enemy: Node2D):
	owner_enemy = enemy  # Asignar el enemigo dueño

func aim_at(target_position: Vector2):
	look_at(target_position)  # La rotamos hacia el jugador

func shoot():
	if not can_fire:
		return  # Evita disparos antes de que termine el cooldown

	can_fire = false
	shoot_timer.start()
	
	if bullet and owner_enemy:
		var bullet_instance = bullet.instantiate() as RigidBody2D
		bullet_instance.global_position = bullet_spawn.global_position
		var direction = (owner_enemy.player.global_position - bullet_spawn.global_position).normalized()
		bullet_instance.launch(direction, bullet_speed)

		get_tree().current_scene.add_child(bullet_instance)  # Agregar la bala al nivel

func _reset_fire():
	can_fire = true  # Permitir disparar de nuevo
