extends Node2D

var level:String
var key_founded = []
var opened_doors = []
var ammo:int = 6
var reserve_ammo:int
var life:float = 100

func get_save_data() -> Dictionary:
	return {
		"level": level,
		"key_founded": key_founded,
		"opened_doors": opened_doors,
		"ammo": ammo,
		"reserve_ammo": reserve_ammo,
		"life": life
	}

func load_from_data(data: Dictionary) -> void:
	level = data.get("level", "")
	key_founded = data.get("key_founded", [])
	opened_doors = data.get("opened_doors", [])
	ammo = data.get("ammo", 6)
	reserve_ammo = data.get("reserve_ammo", 0)
	life = data.get("life", 100.0)
