extends Area2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var knife: Area2D = $"."

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x > global_position.x:
		animated_sprite_2d.flip_v = false
	else:
		animated_sprite_2d.flip_v = true
	if Input.is_action_just_pressed("knife"):
		attack()

func attack():
		animated_sprite_2d.play("attack")
		collision_polygon_2d.disabled = false
		timer.start()


func _on_timer_timeout() -> void:
	collision_polygon_2d.disabled = true
	animated_sprite_2d.play("idle")
