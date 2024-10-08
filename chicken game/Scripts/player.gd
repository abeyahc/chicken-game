extends CharacterBody2D

var accel = 100



@onready var animated_sprite = $AnimatedSprite2D
@onready var healthbar = $Healthbar
@onready var hurtbox = $hurtbox
@onready var death = $"../CanvasLayer/Death"

var input = Vector2.ZERO
var attacked = false

func _ready():
	Global.hp = 100
	healthbar.init_health(Global.hp)
	
	
func _physics_process(delta): # run when game starts
	player_movement(delta)
	
	# gets input direction: -1, 0, 1
	var x_direction = Input.get_axis("move_left", "move_right")
		
	# Flip the Sprite
	if x_direction > 0:
		animated_sprite.flip_h = true
	elif x_direction < 0:
		animated_sprite.flip_h = false

		
	# when going up and down animation plays
	var y_direction = Input.get_axis("move_down", "move_up")
	
	if input == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		if y_direction > 0:
			animated_sprite.play("up")
		elif y_direction < 0:
			animated_sprite.play("down")
		else:
			animated_sprite.play("walk")

	if attacked == true:
		Global.hp -= 1

	if Global.hp > 0:
		_set_health(Global.hp)



func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")) # go left or right
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up")) # go down or up
	return input.normalized()

func player_movement(delta):
	input = get_input() # get return value 
	
	if input == Vector2.ZERO: # no input
		velocity = Vector2.ZERO # Stops
	else:
		velocity = input * accel # speeds character up
		
	move_and_slide()


func _set_health(value):
	healthbar._set_health(value)
	healthbar.health = Global.hp


func _on_hurtbox_body_entered(body):
	attacked = true

func _on_hurtbox_body_exited(body):
	attacked = false
