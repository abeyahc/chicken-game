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
var player = null
var detection_var = false
@export var nav_agent: NavigationAgent2D
var direction = Vector2.ZERO


func _physics_process(delta):
	if player and zone:
		var direction = (player.global_position - global_position).normalized()
		var angle = direction.angle()
		ray_cast_2d.rotation = angle
	
	if (ray_cast_2d.is_colliding() == false) and (player_chase == false) and (detection_var == false):
		print(ray_cast_2d.is_colliding())
		detection_var = true
		detection()
		
	if (player_chase == true):
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

func _on_detection_area_body_entered(body):
	player = body
	zone = true
	detection()
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	zone = false
	detection_var = false
	timer.stop()

func _on_timer_timeout_nav():
	recalc_path()

func _on_timer_timeout():
	player_chase = true
	huh = false

func recalc_path():
	if player:
		nav_agent.target_position = player.global_position
		
func detection():
	huh = true
	timer.start()
