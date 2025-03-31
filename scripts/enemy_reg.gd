extends CharacterBody2D

@onready var pathfollow = get_parent()
@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea
@onready var point_light_2d = $PointLight2D
@onready var gun = $EnemyGun
@onready var idle_timer = $IdleTimer  # Temporizador para el estado idle
@onready var flash_timer: Timer = $flashTimer

var speed: int = 30
var player: Node2D = null
var state: String = "patrol"
var can_fire: bool = false
var reached_end: bool = false  # Controla si terminó el recorrido

@export_enum("linear", "loop") var Patrol_type = "loop"
@export var detection_range: float = 1000.0
@export var idle_time: float = 3.0  # Reducido para pruebas más rápidas

var last_position: Vector2 = Vector2.ZERO
var last_rotation: float = 0.0

func _ready():
	print("Enemy ready!")  # Debug
	last_position = global_position
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	idle_timer.wait_time = idle_time
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	gun.equip(self)

func patrol(delta: float) -> void:
	if state != "patrol":
		return
	
	# Moverse a lo largo del camino
	pathfollow.progress += speed * delta
	
	# Detectar si llegó al final del recorrido
	if Patrol_type == "loop":
		if pathfollow.progress_ratio >= 1.0 and not reached_end:
			reached_end = true
			state = "idle"
			idle_timer.start()
			print("Enemy reached end of patrol, waiting...")  # Debug
			return  # Detener el movimiento
	
	var direction = global_position - last_position
	last_position = global_position

	# Rotar el área de detección y luz
	if direction.length() > 0:
		var angle = direction.angle()
		if abs(angle - last_rotation) > 0.01:
			last_rotation = angle
			detection_area.rotation = angle  
			if not can_fire:
				point_light_2d.rotation = angle

		# Animaciones de movimiento
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

func _physics_process(delta: float):
	match state:
		"idle":
			pass
		"patrol":
			patrol(delta)
		"attack":
			aim_and_shoot()

func _on_idle_timer_timeout():
	reached_end = false
	state = "patrol"
	print("Enemy returning to patrol mode.")  # Debug

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		state = "attack"
		can_fire = true  # Ahora el enemigo puede disparar
		print("Player detected! Switching to attack mode.")  # Debug

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		can_fire = false  # Evita disparos cuando el jugador se va
		state = "patrol"
		print("Player lost, returning to patrol.")  # Debug

func flash():
	sprite.material.set_shader_param("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_param("flash_modifier", 0)
