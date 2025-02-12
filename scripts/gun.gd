extends Node2D
const BULLET = preload("res://scenes/bullet.tscn")



 
@onready var muzzle: Node2D = $"."
 
 
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
 
 
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.apply_impulse(Vector2(), Vector2(50000, 0))
		bullet_instance.rotation = rotation
