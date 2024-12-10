extends TileMapLayer

var player_tile_pos: Vector2i
var player_tile_pos_down: Vector2i
var mouse_tile_pos: Vector2i
var mouse_tile_pos_down: Vector2i


func _use_tile_data_runtime_update(coords):
	if coords in [player_tile_pos, player_tile_pos_down, mouse_tile_pos_down]:
		var atlas_choords = get_cell_atlas_coords(coords)
		return atlas_choords in [FarmTile.TREE_POS, FarmTile.APPLE_HARVESTED_POS, FarmTile.APPLE_POS]
	return true


func _tile_data_runtime_update(coords, tile_data):
	if coords in [player_tile_pos, player_tile_pos_down, mouse_tile_pos_down]:
		tile_data.modulate.a = 0.35
	else:
		tile_data.modulate.a = 1.0


func set_player_pos(player_pos: Vector2, pixel_art_size: Vector2i):
	player_tile_pos = get_tile_pos(player_pos, pixel_art_size)
	player_tile_pos_down = player_tile_pos
	player_tile_pos_down.y += 1


func set_mouse_pos(mouse_pos: Vector2, pixel_art_size: Vector2i):
	mouse_tile_pos = get_tile_pos(mouse_pos, pixel_art_size)
	mouse_tile_pos_down = mouse_tile_pos
	mouse_tile_pos_down.y += 1


func get_tile_pos(pos: Vector2, pixel_art_size: Vector2i) -> Vector2i:
	if pos.x < 0 or pos.y < 0:
		return Vector2i(-1, -1)
	else:
		return Vector2i(pos) / pixel_art_size.x
	
