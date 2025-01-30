extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	var direction1 := Input.get_axis("move_up", "move_down")
	if direction > 0:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("run")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	elif direction == 0:
		animated_sprite.play("idle")
		
	if direction1 > 0:
		velocity.y = direction1 * SPEED
		animated_sprite.play("run")
	elif direction1 < 0:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animated_sprite.play("run")
