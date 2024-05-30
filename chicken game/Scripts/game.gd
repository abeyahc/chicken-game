extends Node2D

@onready var pause_menu = $Player/Camera2D/PauseMenu
@onready var player = $Player
@onready var fox = $fox
const fox_scene = preload("res://Scenes/fox.tscn")
@export var num_foxes = 2



var paused = false

func _ready():
	randomize()
	spawn_foxes(num_foxes)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func spawn_foxes(count):
	for i in range(count):
		var fox_instance = fox_scene.instantiate()
		fox_instance.global_position = Vector2(randi() % 601, randi() % 601)
		add_child(fox_instance)
	
