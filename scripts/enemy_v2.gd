extends CharacterBody2D

@export var speed := 50
@export var patrol_speed := 30.0
@export var detection_range: float = 1000.0
@export var life := 100

@onready var gun: Node2D = $EnemyGun
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var path = get_parent().get_parent()
@onready var path_follow = get_parent()
@onready var recalc_timer: Timer = $Navigation/RecalculateTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_timer: Timer = $deadTimer
@onready var flash_timer: Timer = $flashTimer
@onready var aggro_range: Area2D = $range/aggroRange
@onready var shoot_timer: Timer = $ShootTimer
@onready var flash_material = sprite.material

var player: Node2D = null
var target_node: Node2D = null
var last_position: Vector2 = Vector2.ZERO
var last_rotation: float = 0.0
var patrol_progress := 0.0
var can_fire := false
var is_dead := false
var is_chasing := false
var is_returning_to_path := false
var return_offset := 0.0

func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	sprite.material = null
	gun.equip(self)
	last_position = global_position

func _physics_process(delta):
	if is_dead:
		return

	var direction = global_position - last_position
	last_position = global_position

	# Estado: persiguiendo
	if is_chasing and is_instance_valid(target_node) and target_node.is_in_group("Player"):
		speed = 70
		nav_agent.target_position = target_node.global_position

	# Estado: regresando al path
	elif is_returning_to_path:
		if global_position.distance_to(path.curve.sample(return_offset, true)) < 6.0:
			is_returning_to_path = false
			patrol_progress = return_offset
		else:
			if not nav_agent.is_navigation_finished():
				var axis = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = axis * patrol_speed
				move_and_slide()
				_handle_rotation_and_animation(direction)
			return

	# Estado: patrullando
	else:
		patrol_progress += patrol_speed * delta
		path_follow.progress = patrol_progress
		nav_agent.target_position = path_follow.global_position

	if not nav_agent.is_navigation_finished():
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = axis * speed
		move_and_slide()

	_handle_rotation_and_animation(direction)

func _handle_rotation_and_animation(direction: Vector2) -> void:
	if direction.length() > 0:
		var angle = direction.angle()
		if abs(angle - last_rotation) > 0.01:
			last_rotation = angle
			aggro_range.rotation = angle
		if not can_fire:
			point_light_2d.rotation = angle

		if abs(direction.x) > abs(direction.y):
			sprite.play("move_right" if direction.x > 0 else "move_left")
		else:
			sprite.play("move_down" if direction.y > 0 else "move_up")

func recalc_path():
	if is_chasing and is_instance_valid(target_node) and target_node.is_in_group("Player"):
		nav_agent.target_position = target_node.global_position
	elif is_returning_to_path:
		nav_agent.target_position = path.curve.sample(return_offset, true)
	else:
		nav_agent.target_position = path_follow.global_position

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if is_instance_valid(body) and body.is_in_group("Player"):
		target_node = body
		player = body
		is_chasing = true
		is_returning_to_path = false
		can_fire = true
		shoot_timer.start()
		recalc_path()

func _on_escape_range_body_exited(body: Node2D) -> void:
	if is_instance_valid(body) and body == target_node and body.is_in_group("Player"):
		target_node = null
		is_chasing = false
		can_fire = false
		shoot_timer.stop()
		return_offset = path.curve.get_closest_offset(global_position)
		var return_position = path.curve.sample(return_offset, true)
		nav_agent.target_position = return_position
		is_returning_to_path = true
		recalc_path()

func aim_and_shoot():
	if is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= detection_range:
			gun.aim_at(player.global_position)
			point_light_2d.rotation = (player.global_position - global_position).angle()
			if can_fire:
				gun.shoot()
		else:
			can_fire = false
	else:
		can_fire = false

func take_damage():
	if is_dead:
		return
	life -= 34
	flash()
	if life <= 0:
		is_dead = true
		sprite.play("dead")
		dead_timer.start()

func _on_dead_timer_timeout() -> void:
	queue_free()

func flash():
	sprite.material = flash_material
	flash_material.set("shader_parameter/flash_modifier", 1.0)
	flash_timer.start()

func _on_flash_timer_timeout():
	sprite.material = flash_material
	flash_material.set("shader_parameter/flash_modifier", 0.0)

func _on_shoot_timer_timeout() -> void:
	if can_fire and not is_dead and is_instance_valid(player):
		aim_and_shoot()

func _on_recalculate_timer_timeout() -> void:
	recalc_path()
