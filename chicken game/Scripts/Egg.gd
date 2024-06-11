extends Area2D

var point = 1

func _on_body_entered(body):
	Global.points += point
	print(Global.points)
	queue_free()
	
