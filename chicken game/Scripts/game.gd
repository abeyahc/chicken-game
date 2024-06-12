extends Node2D

@onready var player = $Player
@onready var fox = $fox
const fox_scene = preload("res://Scenes/fox.tscn")
const egg_scene = preload("res://Scenes/Egg.tscn")
const healing = preload("res://Scenes/healer.tscn")
@export var num_foxes = 2
@onready var collisions = $NavigationRegion2D/collisions
var tile_coll_coordinates = []
var healers = 1

func _ready():
	randomize()
	Global.curr_wave = 1
	Global.num_egg = 4
	Global.curr_wave = 1
	for cell in collisions.get_used_cells(0):
		# Convert the cell coordinates to world position if needed
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)

	for cell in collisions.get_used_cells(2):
		# Convert the cell coordinates to world position if needed
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)

	for cell in collisions.get_used_cells(3):
		# Convert the cell coordinates to world position if needed
		var world_position = collisions.map_to_local(cell)
		tile_coll_coordinates.append(world_position)
	
	spawn_foxes(num_foxes)
	spawn_egg(Global.num_egg)
	spawn_healer(healers)
	
func _physics_process(delta):
	if Global.points == Global.num_egg:
		num_foxes = 1
		spawn_foxes(num_foxes)
		Global.num_egg += 2
		spawn_egg(Global.num_egg)
		Global.points = 0
		Global.curr_wave += 1
		spawn_healer(2)

func spawn_healer(count):
	for i in range(count):
		healer_calc_spawn()

func healer_calc_spawn():
	var healer_instance = healing.instantiate()
	
	var over = false
	var rand_healer_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_healer_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	for random_cord in tile_coll_coordinates:
		if random_cord == world_tile_below:
			over = true
			break
	
	if over == true:
		fox_calc_spawn()
	else:
		healer_instance.global_position = world_tile_below
		add_child(healer_instance)



func spawn_foxes(count):
	for i in range(count):
		fox_calc_spawn()

func fox_calc_spawn():
	var fox_instance = fox_scene.instantiate()
	
	var over = false
	var rand_fox_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_fox_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	for random_cord in tile_coll_coordinates:
		if random_cord == world_tile_below:
			over = true
			break
	
	if over == true:
		fox_calc_spawn()
	else:
		fox_instance.global_position = world_tile_below
		add_child(fox_instance)
	
func spawn_egg(count):
	for y in range(count):
		egg_calc_spawn()

func egg_calc_spawn():
	var egg_instance = egg_scene.instantiate()
	
	var over = false
	var rand_fox_position = Vector2(randi_range(-601, 601), randi_range(-475, 600))
	var tile_below = collisions.local_to_map(rand_fox_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	for random_cord in tile_coll_coordinates:
		if random_cord == world_tile_below:
			over = true
			break
	
	if over == true:
		egg_calc_spawn()
	else:
		egg_instance.global_position = world_tile_below
		add_child(egg_instance)




