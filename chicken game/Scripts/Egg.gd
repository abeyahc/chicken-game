extends Area2D

var point = 1

func _on_body_entered(body):
	var game = get_parent()
	game.add_score(point)
	
