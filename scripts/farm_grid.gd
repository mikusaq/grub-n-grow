extends TileMapLayer

# Positions of tiles in atlas
const GRASS_POS = Vector2i(0, 0)
const SOIL_POS = Vector2i(1, 0)
const MULCH_POS = Vector2i(2, 0)
const TREE_POS = Vector2i(3, 0)
const POTATO_SEED_POS = Vector2i(0, 1)
const POTATO_PLANT_POS = Vector2i(1, 1)
const POTATO_HARVEST_POS = Vector2i(2, 1)
const TOMATO_SEED_POS = Vector2i(0, 2)
const TOMATO_PLANT_POS = Vector2i(1, 2)
const TOMATO_HARVEST_POS = Vector2i(2, 2)
const BASIL_SEED_POS = Vector2i(0, 3)
const BASIL_PLANT_POS = Vector2i(1, 3)
const BASIL_HARVEST_POS = Vector2i(2, 3)

signal seed_chosen(seed_tile_pos)

class FarmTileData:
	var tile_pos: Vector2i
	var growing_days: int = 0
	
var farm_tiles: Array[FarmTileData]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_cells_pos : Array[Vector2i] = get_used_cells()
	for tile_pos in all_cells_pos:
		var farm_tile = FarmTileData.new()
		farm_tile.tile_pos = tile_pos
		farm_tiles.append(farm_tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = local_to_map(mouse_pos)
		farm_tile_process_input(tile_mouse_pos)
	elif event.is_action_pressed("1"):
		seed_chosen.emit(POTATO_SEED_POS)
	elif event.is_action_pressed("2"):
		seed_chosen.emit(TOMATO_SEED_POS)
	elif event.is_action_pressed("3"):
		seed_chosen.emit(BASIL_SEED_POS)
	elif event.is_action_pressed("next_day"):
		process_next_day()


func farm_tile_process_input(tile_pos: Vector2i):
	var atlas_choords = get_cell_atlas_coords(tile_pos)
	if atlas_choords == GRASS_POS:
		set_cell(tile_pos, 0, SOIL_POS)
	elif atlas_choords == SOIL_POS:
		set_cell(tile_pos, 0, MULCH_POS)
	elif atlas_choords == MULCH_POS:
		seed_plant(tile_pos)


func seed_plant(tile_pos: Vector2i):
	var sprite_to_set = await seed_chosen
	set_cell(tile_pos, 0, sprite_to_set)


func process_next_day():
	for farm_tile in farm_tiles:
		var atlas_choords = get_cell_atlas_coords(farm_tile.tile_pos)
		var tile_data : TileData = get_cell_tile_data(farm_tile.tile_pos)
		if atlas_choords == POTATO_SEED_POS:
			set_cell(farm_tile.tile_pos, 0, POTATO_PLANT_POS)
		elif atlas_choords == TOMATO_SEED_POS:
			set_cell(farm_tile.tile_pos, 0, TOMATO_PLANT_POS)
		elif atlas_choords == BASIL_SEED_POS:
			set_cell(farm_tile.tile_pos, 0, BASIL_PLANT_POS)
		elif atlas_choords in [POTATO_PLANT_POS, TOMATO_PLANT_POS, BASIL_PLANT_POS]:
			farm_tile.growing_days += 1
			if atlas_choords == POTATO_PLANT_POS:
				if farm_tile.growing_days == 2:
					set_cell(farm_tile.tile_pos, 0, POTATO_HARVEST_POS)
			elif atlas_choords == TOMATO_PLANT_POS:
				if farm_tile.growing_days == 3:
					set_cell(farm_tile.tile_pos, 0, TOMATO_HARVEST_POS)
			elif atlas_choords == BASIL_PLANT_POS:
				if farm_tile.growing_days == 4:
					set_cell(farm_tile.tile_pos, 0, BASIL_HARVEST_POS)
