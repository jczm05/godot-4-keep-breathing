extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Sprite2D = $gun
@onready var timer: Timer = $Timer
@onready var health = Gui.get_node_or_null("health_bar")
var bullet = preload("res://scenes/bullet.tscn")
var footstep_frames:Array = [0,2]
@export var speed = 150
@export var footstep: AudioStream

func _ready():
	progress_bar.value = Global.life
	if health == null:
		print_debug("Health no")

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	if progress_bar.value > 0:
		get_input()
		move_and_slide()
		play_animations()
	Global.life = progress_bar.value

func play_animations():
	if Input.is_action_pressed("move_left"):
		animated_sprite.play("run_left")
		gun.visible = true
		
	elif Input.is_action_pressed("move_right"):
		animated_sprite.play("run_right")
		gun.visible = true
		
	elif Input.is_action_pressed("move_up"):
		animated_sprite.play("run_up")
		gun.visible = false
		
	elif Input.is_action_pressed("move_down"):
		animated_sprite.play("run_down")
		gun.visible = true
		
	else:
		animated_sprite.play("idle")
		gun.visible = true
		

func take_damage():
	progress_bar.value = progress_bar.value - 34
	print("¡Me han disparado! Vida restante: ", progress_bar.value)

	if progress_bar.value <= 66 and progress_bar.value > 33:
		health.play("1")
	elif progress_bar.value <= 33 and progress_bar.value > 0:
		health.play("2")
	elif progress_bar.value <= 0 && is_instance_valid(gun):
		health.play("3")
		animated_sprite.play("death")
		gun.queue_free()
		await get_tree().create_timer(1).timeout
		queue_free()
		health.play("0")
		Global.life = 100
		get_tree().reload_current_scene()
	elif progress_bar.value <= 0 && !is_instance_valid(gun):
		health.play("3")
		animated_sprite.play("death")
		await get_tree().create_timer(1).timeout
		queue_free()
		health.play("0")
		Global.life = 100
		get_tree().reload_current_scene()

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
func _on_animated_sprite_2d_sprite_frames_changed():
	load_sfx(footstep)
	if animated_sprite.frame in footstep_frames: %sfx_player.play()
