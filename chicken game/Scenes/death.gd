extends Control

@onready var game = $"../.."

var is_dead = false: #is_dead starts with a predetermined value of false. Node visibility and process mode are determined here
	set(value):
		is_dead = value
		visible = is_dead
		get_tree().paused = is_dead

func _ready() -> void: 
	is_dead = false

func _physics_process(delta): 
	if Global.hp <= 0: #if player's hp is less or equal to 0 is dead becomes true
		is_dead = true

	if is_dead: #if is_dead then makes previous_wave equal to current wave
		Global.previous_wave = Global.curr_wave
		if Global.curr_wave > Global.high_wave: #if current wave is more than high wave then high wave becomes equal to current wave
			Global.high_wave = Global.curr_wave
		Global.points = 0 #restarts points to 0


#if retry is pressed it restarts game scene
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
#if menu is pressed scene changes to menu
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
#if quit is pressed the game is closed
func _on_quit_pressed():
	get_tree().quit()
