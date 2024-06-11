extends Area2D

var point = 1

func _on_body_entered(body):
	Global.current_score += point
	queue_free()
	
