extends Control

@onready var game = $"../.."

var player_health = 1
var is_dead:bool = false:
	set(value):
		is_dead = value
		visible = is_dead
		get_tree().paused = is_dead

func _ready() -> void:
	is_dead = false

func _physics_process(delta):
	Global.previous_wave = Global.curr_wave
	if Global.curr_wave > Global.high_wave:
		Global.high_wave = Global.curr_wave
		Global.curr_wave = 1
		Global.points = 0

	
	if is_dead:
		visible = is_dead
		get_tree().paused = is_dead

func set_health(value):
	player_health = value
	if player_health <= 0:
		is_dead = !is_dead
		

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
