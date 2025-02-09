extends CharacterBody2D

@export var SPEED = 400

var dir : float
var spawnPos : Vector2

func _ready():
	global_position = spawnPos

func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
