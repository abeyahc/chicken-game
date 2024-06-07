extends CharacterBody2D

var huh = false
var speed = 85
var acceleration = 7
var player_chase = false
@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer
@onready var timer_nav = $Guidance/Timer
@onready var ray_cast_2d = $RayCast2D
var zone = false
var detection_var = false
@export var nav_agent: NavigationAgent2D
var direction = Vector2.ZERO
@onready var player = $"../Player"
var escaping = false


func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	var angle = direction.angle()
	ray_cast_2d.rotation = angle
	
	if (ray_cast_2d.is_colliding() == false) and (player_chase == false) and (detection_var == false) and zone:
		detection_var = true
		detection()
	
	if escaping and global_position.distance_to(nav_agent.get_final_position()) < 1.0:
		escaping = false
	
	if (player_chase == true) or escaping:
		animation.play("attack")
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, acceleration*delta)
		move_and_slide()

		if velocity.x < 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
	elif (player_chase == false) and (huh == false):
		animation.play("idle")
		velocity = Vector2.ZERO
func _on_detection_area_body_entered(body):
	zone = true
	
func _on_detection_area_body_exited(body):
	player_chase = false
	zone = false
	detection_var = false
	escaping= true
	timer.stop()

func _on_timer_timeout_nav():
	recalc_path()

func _on_timer_timeout():
	player_chase = true
	huh = false

func recalc_path():
	if zone and player_chase:
		nav_agent.target_position = player.global_position
		
func detection():
	huh = true
	animation.play("detect")
	timer.start()
