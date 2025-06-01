extends Area2D
@onready var sound: AudioStreamPlayer = $sound

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sound.play()
		var weapons = get_tree().get_nodes_in_group("Gun") # Obtener nodos del grupo "Weapons"
		for gun in weapons:
			gun.set_reserve_ammo(gun.reserve_ammo + 5) # Sumar 5 balas
		queue_free()
