extends CharacterBody2D

@export var speed: float = 100000

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is TileMapLayer:
			queue_free()

func shoot(direction: Vector2):
	velocity = speed * direction.normalized()
	rotation = velocity.angle()
