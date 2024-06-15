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
	#Changes RayCast2D angle towards the player to see if there is a wall between 
	var direction = (player.global_position - global_position).normalized()
	var angle = direction.angle()
	ray_cast_2d.rotation = angle
	
	
	if inside_area: #if player is inside
		if chasing: #if player is being chased it follows the player
			follow(delta)
		else: #if it is not being chased
			if ray_cast_2d.is_colliding(): #If there is a wall between then idle mode stays true
				idle(delta)
			else: # if there isn't a wall between 
				if animation.get_animation() == "detect": #if animation detect is being played spotted becomes equal to true
					spotted = true
				else: #if it is not being played then it plays and detection timer is started
					animation.play("detect")
					detection.start()
	else: #if it is not inside
		if chasing: #chasing is true
			spotted = false #make spotted euqal to false
			if global_position.distance_to(nav_agent.get_final_position()) < 1.0: #if fox arrives to the last known player position chasing becomes equal to false
				chasing = false
			else: #keep moving
				follow(delta)
		else: # if chasing is false then idle mode is activated
			idle(delta)
	
func _on_detection_area_body_entered(body): #If chickens enters the detection area inside_are becomes true
	inside_area = true
	
func _on_detection_area_body_exited(body): #If chickens leaves the detection area inside_are becomes false
	inside_area = false

func _on_timer_timeout_nav(): #Update timer is infinitely going so everytime it reahces 0 it updates the position of the enemy
	recalc_path()

func _on_idle_timeout(): #When Idle timer reaches 0 if wondering is equal false then wondering becomes true
	if (wondering == false):
		wondering = true

func _on_detection_timeout(): #When Detection reahces 0 makes chasing equal to true giving the fox time to play detect animation before it starts chasing the fox
	chasing = true

func follow(delta): 
	#While this function is being played attack animation is being played
	animation.play("attack")
	#direction and veolicity are being updated to chase the player
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, acceleration*delta)
	move_and_slide()
	#depending on which direction the enemy is facing the sprite flips
	if velocity.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

func idle(delta):
	#if relaxing is true then relaxing becomes false idle timer starts idle animation pays while a new coords is being found to go
	if relaxing:
		relaxing = false
		idle_time.start()
		animation.play("idle")
		find_loc()
	#When wonering is true then follow function starts working towards the found coord
	if wondering:
		follow(delta)
		# if the fox reaches the position it makes wondering false and relaxing true
		if global_position.distance_to(nav_agent.get_final_position()) < 15.0:
			wondering = false
			relaxing = true

func find_loc():
	#gets a random position 
	nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	while(nav_agent.is_target_reachable() != true): #if the position can't be reaches it looks for another one until it can be
		nav_agent.target_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))

func recalc_path():
	if (inside_area and chasing) or spotted: #if the player is inside the area and it's being chased or it was spotted then the enemy target position becomes equal to the player position
		nav_agent.target_position = player.global_position
