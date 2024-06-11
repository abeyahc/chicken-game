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
	Global.previous_score = Global.current_score
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	Global.current_score = 0
	print(Global.high_score)
	
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
