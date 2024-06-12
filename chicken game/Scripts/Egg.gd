extends Area2D

var point = 1

func _on_body_entered(body):
	Global.points += point
	queue_free()
	
