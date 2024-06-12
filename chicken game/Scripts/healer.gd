extends Area2D

func _on_body_entered(body):
	if (Global.hp >= 85) and (Global.hp <= 99):
		Global.hp = 100
		queue_free()
	elif (Global.hp < 85) and (Global.hp > 0):
		Global.hp += 15
		queue_free()
	else:
		pass

