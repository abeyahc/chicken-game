extends CharacterBody2D

var state_machine
var speed = 25
var player_chase = false
var player = null
@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer


func _ready():
	# connect animations
	state_machine = $AnimatedSprite2D/AnimationTree.get("parameters/playback")
	# connect timer's timeout signal to custom function
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _physics_process(delta):
	if player_chase:
		# collide with tiles
		move_and_collide(Vector2(0,0)) 

		# change position of enemy
		position += (player.position - position) / speed 
		
		if (player.position.x - position.x) < 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
	else:
		state_machine.travel("idle")

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
	
func start_detect_sequence():
	# Play the detect animation and start the timer
	state_machine.travel("detect")
	timer.start()  # Start the timer

func _on_Timer_timeout():
	# When the timer times out, start chasing the player
	player_chase = true
	attack()  # Play the attack animation and start chasing


