extends Control

func _ready():
	visible = false

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
