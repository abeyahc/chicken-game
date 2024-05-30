extends TileMap

@onready var player = $"../Player"

func _process(delta):
	var player_position = player.global_position
	if (player_position > Vector2(-320, -145)) and (player_position > Vector2(-320, -125)) and (player_position < Vector2(-210, -145)) and (player_position < Vector2(-210, -125)):
		modulate.a = 0.5  # Semi-transparent
	else:
		modulate.a = 1.0  # Fully opaque
