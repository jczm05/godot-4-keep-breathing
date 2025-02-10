extends Area2D
@onready var player_node: CharacterBody2D = $"../../Player_Node"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D


func _on_body_entered(CharacterBody2D):
	if CharacterBody2D == player_node:
		animated_sprite.play("detected")
		print("aaaaa")
		light.color = Color.RED


func _on_body_exited(_player_node):
	animated_sprite.play("idle")
	light.color = Color.WHITE
