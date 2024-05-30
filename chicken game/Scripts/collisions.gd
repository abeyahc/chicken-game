extends TileMap

# Assuming $TileMap is the TileMap node and $Player is the player node
@onready var collisions = $"."
@onready var player = $"../Player"
var layer = 1
var tile_coordinates = []
var behind = false

func _ready():
	# Assuming you are interested in layer 0. Change this if you need a different layer.
	
	# Get the used cells in the specified layer
	for cell in collisions.get_used_cells(layer):
		# Convert the cell coordinates to world position if needed
		var world_position = collisions.map_to_local(cell)
		tile_coordinates.append(world_position)


func _process(delta):
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
		modulate.a = 0.5  # Semi-transparent
	else:
		modulate.a = 1.0  # Fully opaque

