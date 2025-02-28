extends Node2D
var bullet_speed = 900
var bullet = preload("res://scenes/bullet.tscn")
@onready var bullet_spawn: Marker2D = $bullet_spawn
@onready var shoot_speed_timer: Timer = $shootSpeedTimer
var canShoot = true
var shootSpeed = 2.0
@onready var gun: Sprite2D = $"."
@onready var ammo_reserves_label = get_node("/root/Gui/_ammo_reserves_label")
@onready var current_ammo_label = get_node("/root/Gui/_current_ammo_label")
var max_ammo = 12: set = set_max_ammo
var _current_ammo = max_ammo
var reserve_ammo := 12:set = set_reserve_ammo
@onready var reload_timer: Timer = $reloadTimer

var _reload_time := 1.0: set = set_reload_time

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	current_ammo_label.text = str(_current_ammo)
	ammo_reserves_label.text = str(reserve_ammo)
	if get_global_mouse_position().x > global_position.x:
		gun.flip_v = false
	else:
		gun.flip_v = true
	
	if Input.is_action_just_pressed("shoot"):
		if _current_ammo > 0:
			fire()
		else:
			reload()
	elif Input.is_action_just_pressed("reload") and _current_ammo < max_ammo:
		reload()

func fire():
	if canShoot:
		canShoot = false
		shoot_speed_timer.start()
		_current_ammo -= 1
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = bullet_spawn.global_position
		current_ammo_label.text = str(_current_ammo)
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - bullet_spawn.global_position).normalized()
		bullet_instance.rotation = direction.angle()
		bullet_instance.apply_impulse(direction * bullet_speed)
		get_tree().root.call_deferred("add_child", bullet_instance)
		

func reload() -> void:
	if reserve_ammo <= 0:
		return
	reload_timer.start(_reload_time)
	refill_ammo()

func refill_ammo():
	var ammo_missing = max_ammo - _current_ammo
	
	if reserve_ammo >= ammo_missing:
		set_reserve_ammo(reserve_ammo - ammo_missing)
		_current_ammo = max_ammo
	else:
		_current_ammo += reserve_ammo
		set_reserve_ammo(0)


func _on_shoot_speed_timer_timeout() -> void:
	canShoot = true

func set_max_ammo(value:int) -> void:
	max_ammo = value
	refill_ammo()

func set_reserve_ammo(value: int) -> void:
	reserve_ammo = value
	ammo_reserves_label.text = str(reserve_ammo)

func set_reload_time(value: float) -> void:
	_reload_time = value
