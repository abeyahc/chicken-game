extends TileMap

# Assuming $TileMap is the TileMap node and $Player is the player node
@onready var collisions = $"."
@onready var player = $"../Player"
var layer = 1
var tile_coordinates = []
var behind = false
@onready var color_rect = $ColorRect


func _process(delta):
	for i in range(collisions.get_layers_count()): #checks each layer 
		layer_info(i + 1)

func layer_info(layer):
	for cell in collisions.get_used_cells(layer):
		# Convert the cell coordinates to world position if needed
		var world_position = collisions.map_to_local(cell)
		tile_coordinates.append(world_position)
		conditional_func(layer)
	tile_coordinates.clear()

func conditional_func(layer):
	# Get the player's position
	var player_position = player.position
	# Convert the player's position to the map (cell) position
	var tile_below = collisions.local_to_map(player_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	behind = false
	for coord in tile_coordinates:
		if coord == world_tile_below:
			behind = true
			break
	if behind:
		set_layer_modulate(layer,Color(1, 1, 1, 0.5))  # Semi-transparent
	else:
		set_layer_modulate(layer,Color(1, 1, 1, 1)) # Full visible
