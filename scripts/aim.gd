extends Line2D

@onready var gun: Sprite2D = $"../gun"
var max_distance = 2000

func _process(_delta):
	if Input.is_action_pressed("aim"):
		var start_pos = gun.global_position
		var mouse_pos = get_global_mouse_position()

		var direction = (mouse_pos - start_pos).normalized()
		var target_pos = start_pos + (direction * max_distance)

		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(start_pos, target_pos)
		query.collide_with_areas = false
		query.collide_with_bodies = true

		var closest_hit = null

		var tilemaps = get_tree().get_nodes_in_group("Escenario")
		for tilemap in tilemaps:
			var result = space_state.intersect_ray(query)
			if result and (closest_hit == null or result.position.distance_to(start_pos) < closest_hit.position.distance_to(start_pos)):
				closest_hit = result

		if closest_hit:
			target_pos = closest_hit.position

		if get_point_count() < 2:
			add_point(Vector2.ZERO)
			add_point(Vector2.ZERO)
		set_point_position(0, to_local(start_pos))
		set_point_position(1, to_local(target_pos))

	else:
		clear_points()
