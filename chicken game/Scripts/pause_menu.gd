extends Control
@onready var game = $"../.."

var is_paused:bool = false:
	set(value):
		is_paused = value
		visible = is_paused
		get_tree().paused = is_paused
		
func _ready() -> void:
	is_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused

func _on_resume_pressed():
	is_paused = false

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
