extends Area2D

func _on_body_entered(body):
	if (Global.hp >= 85) and (Global.hp <= 99): #if hp is between 85 and 99, hp is restarted to 100 and then helaer is removed
		Global.hp = 100
		queue_free()
	elif (Global.hp < 85) and (Global.hp > 0): #if hp is between 84 and 0, 15 is added to hp and then helaer is removed
		Global.hp += 15
		queue_free()
	else: #if any of this is true then nothing happens
		pass

