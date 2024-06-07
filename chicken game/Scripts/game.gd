extends Node2D

@onready var player = $Player
@onready var fox = $fox
const fox_scene = preload("res://Scenes/fox.tscn")
@export var num_foxes = 5
@onready var collisions = $NavigationRegion2D/collisions

var tile_coll_coordinates = []


func _ready():
	randomize()
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

func spawn_foxes(count):
	for i in range(count):
		calc_spawn()

func calc_spawn():
	var fox_instance = fox_scene.instantiate()
	
	var over = false
	var rand_fox_position = Vector2(randi_range(-601, 601), randi_range(-601, 601))
	var tile_below = collisions.local_to_map(rand_fox_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	
	for random_cord in tile_coll_coordinates:
		if random_cord == world_tile_below:
			over = true
			break
	
	if over == true:
		calc_spawn()
	else:
		fox_instance.global_position = world_tile_below
		add_child(fox_instance)
	
	
	
