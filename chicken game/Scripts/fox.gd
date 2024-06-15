extends CharacterBody2D

var speed = 90
var acceleration = 7
@onready var animation = $AnimatedSprite2D
@onready var detection = $Detection
@onready var update = $Guidance/Update
@onready var ray_cast_2d = $RayCast2D
@export var nav_agent: NavigationAgent2D
var direction = Vector2.ZERO
@onready var player = $"../Player"
@onready var idle_time = $Idle
var inside_area = false
var chasing = false
var spotted = false
var wondering = false
var relaxing = true

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	var angle = direction.angle()
	ray_cast_2d.rotation = angle
	
	if inside_area:
		if chasing:
			follow(delta)
		else:
			if ray_cast_2d.is_colliding():
				idle(delta)
			else:
				if animation.get_animation() == "detect":
					spotted = true
				else:
					animation.play("detect")
					detection.start()
	else:
		if chasing:
			spotted = false
			if global_position.distance_to(nav_agent.get_final_position()) < 1.0:
				chasing = false
			else:
				follow(delta)
		else:
			idle(delta)
	
func _on_detection_area_body_entered(body):
	inside_area = true
	
func _on_detection_area_body_exited(body):
	inside_area = false

func _on_timer_timeout_nav():
	recalc_path()

func _on_idle_timeout():
	if (wondering == false):
		wondering = true

func _on_detection_timeout():
	chasing = true

func follow(delta):
	animation.play("attack")
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, acceleration*delta)
	move_and_slide()

	if velocity.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

func idle(delta):
	if relaxing:
		relaxing = false
		idle_time.start()
		animation.play("idle")
		find_loc()
	if wondering:
		follow(delta)
		
		if global_position.distance_to(nav_agent.get_final_position()) < 15.0:
			wondering = false
			relaxing = true

func find_loc():
	nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	while(nav_agent.is_target_reachable() != true):
		nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))

func recalc_path():
	if (inside_area and chasing) or spotted:
		nav_agent.target_position = player.global_position
