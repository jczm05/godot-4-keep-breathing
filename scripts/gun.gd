extends Node2D
var bullet_speed = 700
var bullet = preload("res://scenes/bullet.tscn")
@onready var bullet_spawn: Marker2D = $bullet_spawn
@onready var shoot_speed_timer: Timer = $shootSpeedTimer
var canShoot = true
var shootSpeed = 2.0
@onready var gun: Sprite2D = $"."

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x > global_position.x:
		gun.flip_v = false
	else:
		gun.flip_v = true
	
	if Input.is_action_just_pressed("shoot"):
		fire()


func fire():
	if canShoot:
		canShoot = false
		shoot_speed_timer.start()
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = bullet_spawn.global_position
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - bullet_spawn.global_position).normalized()
		bullet_instance.rotation = direction.angle()
		bullet_instance.apply_impulse(direction * bullet_speed)
		get_tree().root.call_deferred("add_child", bullet_instance)
		

func _on_shoot_speed_timer_timeout() -> void:
	canShoot = true
