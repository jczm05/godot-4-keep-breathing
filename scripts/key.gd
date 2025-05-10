extends Node2D

func _ready() -> void:
	if self.name in Global.key_founded:
		queue_free()
	if self.name in Global.key_founded:
		Gui.get_node(""+self.name).show()
	

func _on_area_2d_body_entered(_body):
	Global.key_founded.append(self.name)
	queue_free()
	Gui.get_node(""+self.name).show()
