extends CharacterBody2D

@onready var pathfollow = get_parent()
@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea
@onready var point_light_2d = $PointLight2D
@onready var gun = $EnemyGun
@onready var idle_timer = $IdleTimer
@onready var flash_timer: Timer = $flashTimer
@onready var flash_material = sprite.material
@onready var dead_timer: Timer = $deadTimer
var is_dead = false

var speed: int = 30
var player: Node2D = null
var state: String = "idle" #cambiar y mirar
var can_fire: bool = false
var reached_end: bool = false

@export_enum("linear", "loop") var Patrol_type = "loop"
@export var detection_range: float = 1000.0
@export var idle_time: float = 3.0

var last_position: Vector2 = Vector2.ZERO
var last_rotation: float = 0.0
var life: int = 100

func _ready():
	sprite.material = null
	print("Enemy ready!")
	last_position = global_position
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	idle_timer.wait_time = idle_time
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	gun.equip(self)
	


func _physics_process(delta: float):
	if is_dead:
		return
	match state:
		"idle":
			pass
		"patrol":
			patrol(delta)
		"attack":
			aim_and_shoot()

func patrol(delta: float) -> void:
	if state != "patrol" or is_dead:
		return

	pathfollow.progress += speed * delta

	if Patrol_type == "loop":
		if pathfollow.progress_ratio >= 1.0 and not reached_end:
			reached_end = true
			state = "idle"
			idle_timer.start()
			print("Enemy reached end of patrol, waiting...")
			return

	var direction = global_position - last_position
	last_position = global_position

	if direction.length() > 0:
		var angle = direction.angle()
		if abs(angle - last_rotation) > 0.01:
			last_rotation = angle
			detection_area.rotation = angle
			if not can_fire:
				point_light_2d.rotation = angle

		if abs(direction.x) > abs(direction.y):
			sprite.play("move_right" if direction.x > 0 else "move_left")
		else:
			sprite.play("move_down" if direction.y > 0 else "move_up")

func aim_and_shoot():
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= detection_range:
			gun.aim_at(player.global_position)
			point_light_2d.rotation = (player.global_position - global_position).angle()
			if can_fire:
				gun.shoot()
		else:
			can_fire = false
			state = "patrol"



func _on_idle_timer_timeout():
	reached_end = false
	state = "patrol"
	print("Enemy returning to patrol mode.")

func _on_detection_area_body_entered(body):
	if is_dead:
		return
	if body.is_in_group("Player"):
		player = body
		state = "attack"
		can_fire = true
		print("Player detected! Switching to attack mode.")

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		can_fire = false
		state = "patrol"
		print("Player lost, returning to patrol.")


func flash():
	sprite.material = flash_material
	flash_material.set("shader_parameter/flash_modifier", 1.0)
	flash_timer.start()


func _on_flash_timer_timeout():
	sprite.material = flash_material
	flash_material.set("shader_parameter/flash_modifier", 0.0)



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
