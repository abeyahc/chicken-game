extends Area2D

func _on_body_entered(body): #if player touches the egg score is increased by 1 and then is eliminated
	Global.points += 1
	queue_free()
	
