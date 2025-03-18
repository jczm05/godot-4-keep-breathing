extends RigidBody2D
class_name Bullet
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D

#You can use this signal to alert other nodes that the bullet hit something
signal hit_something  
signal hit(target)

#Variable for keeping track of it's velocity        
var velocity:Vector2    


#Set the velocity of the bullet  
#Call this right after creating the bullet to make it start moving
func launch(direction:Vector2, speed:float):    
	velocity = direction * speed    

#This is automatically called every physics update.
func _physics_process(_delta):  
	#Move the bullet using it's previously defined velocity  
	#And save any collisions that may happen.
	var collision = move_and_collide(velocity)    

	#If it hit something, emit the signal from earlier
	if collision != null:    
		freeze = true
		point_light_2d.color = Color.YELLOW
		sprite_2d.play("explode")
		hit_something.emit()
		await get_tree().create_timer(0.05).timeout
		queue_free() 

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		emit_signal("hit", body) 
		queue_free()  
