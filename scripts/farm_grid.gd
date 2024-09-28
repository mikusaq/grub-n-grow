extends TileMapLayer

# Positions of tiles in atlas
const GRASS_POS = Vector2i(0, 0)
const MULCH_POS = Vector2i(1, 0)
const SEED_POS = Vector2i(2, 0)
const PLANT_POS = Vector2i(0, 1)
const HARVEST_POS = Vector2i(0, 2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = local_to_map(mouse_pos)
		farm_tile_process_input(tile_mouse_pos)


func farm_tile_process_input(tile_pos):
	var atlas_choords = get_cell_atlas_coords(tile_pos)
	if atlas_choords == GRASS_POS:
		set_cell(tile_pos, 0, MULCH_POS)
	elif atlas_choords == MULCH_POS:
		set_cell(tile_pos, 0, SEED_POS)
