extends Node2D

@onready var player = $Player
@onready var fox = $fox
const fox_scene = preload("res://Scenes/fox.tscn")
const egg_scene = preload("res://Scenes/Egg.tscn")
const healing = preload("res://Scenes/healer.tscn")
@export var num_foxes = 3
@onready var collisions = $collisions
var tile_coll_coordinates = []
var healers = 1

func _ready():
	Global.curr_wave = 1 #when scene is first played current wave is equal to 1
	Global.num_egg = 4 #when scene is first played number of eggs is equal to 4
	
	
	# the next 3 loops collect all of the coords with all of the layers with collision to avoid objects and enemies spawning over
	for cell in collisions.get_used_cells(0):
		# Convert the cell coordinates to world position
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)

	for cell in collisions.get_used_cells(2):
		# Convert the cell coordinates to world position 
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)

	for cell in collisions.get_used_cells(3):
		# Convert the cell coordinates to world position 
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)
	
	#spawn foxes, eggs and healers
	spawn_foxes(num_foxes)
	spawn_egg(Global.num_egg)
	spawn_healer(healers)
	
func _physics_process(delta):
	if Global.points == Global.num_egg: #if number of points is equal to the number of total eggs
		#Restarts the number of foxes and then spawns
		num_foxes = 1 
		spawn_foxes(num_foxes)
		#adds 2 more to the total of number of eggs and then spawns them
		Global.num_egg += 2
		spawn_egg(Global.num_egg)
		#Restarts the points and the current wave increases by 1
		Global.points = 0
		Global.curr_wave += 1
		#2 healers spawn
		spawn_healer(2)

func spawn_healer(count):
	#calls healer spawner the number of times given
	for i in range(count):
		healer_calc_spawn()

func healer_calc_spawn():
	#calls healer scene
	var healer_instance = healing.instantiate()
	#looks for a position on where to spawn it
	var over = false
	var rand_healer_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_healer_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	#Check all of the positions in the list and compares them with the random position
	for random_cord in tile_coll_coordinates:
		# if the given position is over a any of the tiles it stops the search
		if random_cord == world_tile_below:
			over = true
			break
	#It calls the function again if not then the object is spawned
	if over == true:
		fox_calc_spawn()
	else:
		healer_instance.global_position = world_tile_below
		add_child(healer_instance)


func spawn_foxes(count):
	#calls fox spawner the number of times given
	for i in range(count):
		fox_calc_spawn()

func fox_calc_spawn():
	#calls fox scene
	var fox_instance = fox_scene.instantiate()
	
	#looks for a position on where to spawn it
	var over = false
	var rand_fox_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_fox_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	#Check all of the positions in the list and compares them with the random position
	for random_cord in tile_coll_coordinates:
		# if the given position is over a any of the tiles it stops the search
		if random_cord == world_tile_below:
			over = true
			break
	
	#It calls the function again if not then the object is spawned
	if over == true:
		fox_calc_spawn()
	else:
		fox_instance.global_position = world_tile_below
		add_child(fox_instance)
	
func spawn_egg(count):
	#calls egg spawner the number of times given
	for y in range(count):
		egg_calc_spawn()

func egg_calc_spawn():
	#calls egg scene
	var egg_instance = egg_scene.instantiate()
	
	#looks for a position on where to spawn it
	var over = false
	var rand_fox_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_fox_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	#Check all of the positions in the list and compares them with the random position
	for random_cord in tile_coll_coordinates:
		# if the given position is over a any of the tiles it stops the search
		if random_cord == world_tile_below:
			over = true
			break
	
	#It calls the function again if not then the object is spawned
	if over == true:
		egg_calc_spawn()
	else:
		egg_instance.global_position = world_tile_below
		add_child(egg_instance)




