extends RigidBody2D
class_name Bullet
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D


#Variable for keeping track of it's velocity        
var velocity:Vector2    
var has_hit = false

#Set the velocity of the bullet  
#Call this right after creating the bullet to make it start moving
func launch(direction:Vector2, speed:float):    
	velocity = direction * speed    

#This is automatically called every physics update.
func _physics_process(delta):  
	#Move the bullet using it's previously defined velocity  
	#And save any collisions that may happen.
	if has_hit:
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
		has_hit = true
		var body = collision.get_collider()
		if body.has_method("take_damage"):
			body.take_damage()
		freeze = true
		point_light_2d.color = Color.YELLOW
		sprite_2d.play("explode")
		await get_tree().create_timer(0.05).timeout
		queue_free()
