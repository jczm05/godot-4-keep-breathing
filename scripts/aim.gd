extends Line2D

@onready var gun: Sprite2D = $"../gun"  

func _process(_delta):
	if Input.is_action_pressed("aim"):
		var start_pos = gun.global_position 
		var target_pos = get_global_mouse_position()

		if get_point_count() < 2:
			add_point(Vector2.ZERO) 
			add_point(Vector2.ZERO) 

		set_point_position(0, to_local(start_pos)) 
		set_point_position(1, to_local(target_pos)) 
	else:
		clear_points()  
