extends CharacterBody2D

@onready var pathfollow = get_parent()
@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea
@onready var point_light_2d = $PointLight2D
@onready var gun = $EnemyGun
@onready var idle_timer = $IdleTimer  # Temporizador para el estado idle

var speed: int = 30
var player: Node2D = null
var state: String = "patrol"
var can_fire: bool 
var reached_end: bool = false  # Controla si terminó el recorrido

@export_enum("linear", "loop") var Patrol_type = "loop"
@export var detection_range: float = 200.0
@export var idle_time: float = 30.0  # Tiempo de espera en estado "idle"

var last_position: Vector2 = Vector2.ZERO
var last_rotation: float = 0.0

func _ready():
	last_position = global_position
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	idle_timer.wait_time = idle_time  # Configurar el temporizador de idle
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
			var direction = (player.global_position - global_position).normalized()
			var angle = direction.angle()
			gun.aim_at(player.global_position)
			
			# Solo dispara si puede hacerlo
			if can_fire:
				gun.shoot()
			
			point_light_2d.rotation = angle
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
	state = "patrol"  # Volver a patrullar

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		state = "attack"

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		state = "patrol"
