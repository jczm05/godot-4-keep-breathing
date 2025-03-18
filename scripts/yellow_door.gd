extends StaticBody2D

func _ready() -> void:
	if self.name in Global.opened_doors:
		queue_free()

func _on_area_2d_body_entered(_body: Node2D):
	if "YellowKey" in Global.key_founded:
		Global.opened_doors.append(self.name)
		queue_free()
