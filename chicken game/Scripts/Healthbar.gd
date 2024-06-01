extends ProgressBar

@onready var timer = $Timer
@onready var damagebar = $Damagebar

var health = 0 

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		damagebar.value = health # immediately fills up to health bar

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health # both bars will be completely full
	damagebar.value = health
	print(health)

func _on_timer_timeout():
	damagebar.value = health # damage bar catches up to health bar


