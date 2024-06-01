extends Node2D

@onready var player = $Player
@onready var fox = $fox
const fox_scene = preload("res://Scenes/fox.tscn")
@export var num_foxes = 2
@onready var collisions = $collisions
@onready var pause_menu = $CanvasLayer/PauseMenu


func _ready():
	randomize()
	spawn_foxes(num_foxes)
	
	
func spawn_foxes(count):
	for i in range(count):
		var fox_instance = fox_scene.instantiate()
		fox_instance.global_position = Vector2(randi() % 601, randi() % 601)
		add_child(fox_instance)


