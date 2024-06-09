extends CharacterBody2D

var huh = false
var speed = 85
var acceleration = 7
var player_chase = false
@onready var animation = $AnimatedSprite2D
@onready var timer = $Detection
@onready var update = $Guidance/Update
@onready var ray_cast_2d = $RayCast2D
var zone = false
var detection_var = false
@export var nav_agent: NavigationAgent2D
var direction = Vector2.ZERO
@onready var player = $"../Player"
var escaping = false
var wondering = false
var idle_con = true
@onready var idle_time = $Idle

func _ready():
	idle_time.start()

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
		if idle_con and (wondering == false):
			animation.play("idle")
		elif (idle_con == false) and (wondering == false):
			idle()
		elif (idle_con == false) and wondering:
			idle_condition(delta)

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


func _on_idle_timeout():
	idle_con = false
	idle_time.stop()

func idle():
	wondering = true
	nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-601, 601))
	while(nav_agent.is_target_reachable() != true):
		nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-601, 601))

func idle_condition(delta):
	animation.play("attack")
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, acceleration*delta)
	move_and_slide()
	
	if velocity.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false
	
	if global_position.distance_to(nav_agent.get_final_position()) < 1.0:
		wondering = false
		idle_con = true
		idle_time.start()
	
