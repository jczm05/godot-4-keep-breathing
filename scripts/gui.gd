extends CanvasLayer
@onready var yellow_key: Sprite2D = $YellowKey


func _ready() -> void:
	if "YellowKey" in Global.key_founded:
		yellow_key.show()
	
