extends TileMap

# Assuming $TileMap is the TileMap node and $Player is the player node
@onready var collisions = $"."
var tile_coordinates = []
var behind = false
@onready var color_rect = $ColorRect
@onready var player = $"../../Player"



func _process(delta):
	for i in range(collisions.get_layers_count() - 3): #checks each layer excluding the first 3
		layer_info(i + 3)

func layer_info(layer):
	for cell in collisions.get_used_cells(layer): #goes over each tiles in each layer
		# Convert the cell coordinates to world position if needed and stores each position in the list to be reviewed on the conditional_func
		var world_position = collisions.map_to_local(cell)
		tile_coordinates.append(world_position)
		conditional_func(layer)
	tile_coordinates.clear() #restarts the list to check the next layer

func conditional_func(layer):
	# Get the player's position
	var player_position = player.position
	# Convert the player's position to the map (cell) position
	var tile_below = collisions.local_to_map(player_position)
	var world_tile_below = collisions.map_to_local(tile_below)
	behind = false
	for coord in tile_coordinates: #checks each coord to check if the player is over it
		if coord == world_tile_below:#if it is it makes behind = true and stops checking
			behind = true
			break
	if behind: #if true makes the layer semi transparent else it stays fully visible
		set_layer_modulate(layer,Color(1, 1, 1, 0.5))  # Semi-transparent
	else:
		set_layer_modulate(layer,Color(1, 1, 1, 1)) # Full visible
