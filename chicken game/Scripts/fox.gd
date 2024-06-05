extends CharacterBody2D

var state_machine
var speed = 100
var acceleration = 7
var player_chase = false
@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer

var player = null
@export var nav_agent: NavigationAgent2D


func _ready():
	# connect animations
	state_machine = $AnimatedSprite2D/AnimationTree.get("parameters/playback")
	# connect timer's timeout signal to custom function
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if player_chase:
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, acceleration*delta)
		move_and_slide()
	
	#if player_chase:
		# collide with tiles
		#move_and_collide(Vector2(0,0)) 

		# change position of enemy
		#position += (player.position - position) / speed 
		
		#if (player.position.x - position.x) < 0:
			#animation.flip_h = true
		#else:
			#animation.flip_h = false
	#else:
		#state_machine.travel("idle")

func recalc_path():
	if player:
		nav_agent.target_position = player.global_position

func sleep():
	state_machine.travel("sleep")
func attack():
	state_machine.travel("attack")

func _on_detection_area_body_entered(body):
	player = body
	start_detect_sequence()

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	timer.stop()
	velocity = Vector2.ZERO
	
func start_detect_sequence():
	# Play the detect animation and start the timer
	state_machine.travel("detect")
	timer.start()  # Start the timer

func _on_Timer_timeout():
	# When the timer times out, start chasing the player
	player_chase = true
	recalc_path()
	attack()  # Play the attack animation and start chasing

func _on_path_completed():
	player_chase = false
	velocity = Vector2.ZERO  # Stop movement when the path is completed
	sleep()  # Transition to sleep state if needed
	

func _on_timer_timeout_nav():
	recalc_path()
