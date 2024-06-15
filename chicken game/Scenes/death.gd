extends Control

@onready var game = $"../.."

var is_dead:bool = false:
	set(value):
		is_dead = value
		visible = is_dead
		get_tree().paused = is_dead

func _ready() -> void:
	is_dead = false

func _physics_process(delta):
	if Global.hp <= 0:
		is_dead = true

	if is_dead:
		Global.previous_wave = Global.curr_wave
		if Global.curr_wave > Global.high_wave:
			Global.high_wave = Global.curr_wave
		Global.points = 0
		visible = is_dead
		get_tree().paused = is_dead

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
