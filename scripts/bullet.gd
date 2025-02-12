extends RigidBody2D

@export var speed: float = 500.0  # Velocidad de la bala
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: TileMapLayer):
	if body.is_in_group("Escenario"):
		print("pium")
		queue_free()

func _on_area_entered(area: TileMapLayer):
	if area.is_in_group("Escenario"):
		print("pium")
		queue_free()
