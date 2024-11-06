extends TileMapLayer

var player_tile_pos: Vector2i

func _use_tile_data_runtime_update(coords):
	if player_tile_pos == coords:
		return get_cell_atlas_coords(coords) == FarmTile.TREE_POS
	return true


func _tile_data_runtime_update(coords, tile_data):
	if player_tile_pos == coords:
		tile_data.modulate.a = 0.4
	else:
		tile_data.modulate.a = 1.0
