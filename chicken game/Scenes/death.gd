extends Control

@onready var game = $"../.."

var player_health = 1
var is_paused: bool = false

func _ready() -> void:
	is_paused = false
	visible = is_paused

func set_health(value):
	player_health = value
	if player_health <= 0:
		is_paused = true
		visible = is_paused

func _unhandled_input(event: InputEvent) -> void:
	pass  # We don't handle input directly here, as pause state is tied to player_health

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
