extends CharacterBody2D


const SPEED = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta) -> void:
	# Add the gravity.
	

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	var direction2 := Input.get_axis("move_up","move_down")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.y, 0, SPEED)
	if direction2:
		velocity.y = direction2 * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Flip in directions 
	if direction == 0:
		animated_sprite.flip_h = false
	elif direction > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("move_idle")
	else:
		animated_sprite.flip_h = true
		animated_sprite.play("move_idle")
	
	if direction != 0 && direction2 != 0:
		animated_sprite.play("up_down")
	
	if direction2 == 0:
		animated_sprite.flip_v = true
	elif direction2 > 0:
		animated_sprite.flip_v = true
		animated_sprite.play("up_down")
	else:
		animated_sprite.flip_v = false
		animated_sprite.play("up_down")
		
	move_and_slide()
