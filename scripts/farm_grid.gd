class_name FarmGrid extends TileMapLayer

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

signal seed_chosen(plant_type: FarmTile.PlantType)
	
var farm_tiles: Array[FarmTile]


func get_farm_tile(tile_pos: Vector2i) -> FarmTile:
	for farm_tile in farm_tiles:
		if farm_tile.tile_pos == tile_pos:
			return farm_tile
	return null


func get_surrounding_farm_tiles(farm_tile: FarmTile) -> Array[FarmTile]:
	var farm_tiles: Array[FarmTile]
	var surrounding_cells = get_surrounding_cells(farm_tile.tile_pos)
	for cell in surrounding_cells:
		if cell.x >= 0 and cell.y < 5:
			farm_tiles.append(get_farm_tile(cell))
	return farm_tiles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_cells_pos : Array[Vector2i] = get_used_cells()
	for tile_pos in all_cells_pos:
		var farm_tile = FarmTile.new()
		farm_tile.farm_grid = self
		farm_tile.tile_pos = tile_pos
		farm_tile.atlas_choords = get_cell_atlas_coords(tile_pos)
		if farm_tile.atlas_choords == TREE_POS:
			farm_tile.plant_type = FarmTile.PlantType.TREE
		farm_tiles.append(farm_tile)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = local_to_map(mouse_pos)
		var farm_tile = get_farm_tile(tile_mouse_pos)
		process_input_on_farm_tile(farm_tile)
	elif event.is_action_pressed("1"):
		seed_chosen.emit(FarmTile.PlantType.POTATO)
	elif event.is_action_pressed("2"):
		seed_chosen.emit(FarmTile.PlantType.TOMATO)
	elif event.is_action_pressed("3"):
		seed_chosen.emit(FarmTile.PlantType.BASIL)
	elif event.is_action_pressed("next_day"):
		process_next_day()


func process_input_on_farm_tile(farm_tile: FarmTile):
	if farm_tile.atlas_choords == GRASS_POS:
		farm_tile.atlas_choords = SOIL_POS
	elif farm_tile.atlas_choords == SOIL_POS:
		farm_tile.atlas_choords = MULCH_POS
	elif farm_tile.atlas_choords == MULCH_POS:
		var plant_to_seed = await seed_chosen
		farm_tile.seed_plant(plant_to_seed)
	elif farm_tile.atlas_choords in [POTATO_HARVEST_POS, TOMATO_HARVEST_POS, BASIL_HARVEST_POS]:
		harvest(farm_tile)


func process_next_day():
	for farm_tile in farm_tiles:
		if farm_tile.atlas_choords == POTATO_SEED_POS:
			farm_tile.atlas_choords = POTATO_PLANT_POS
		elif farm_tile.atlas_choords == TOMATO_SEED_POS:
			farm_tile.atlas_choords = TOMATO_PLANT_POS
		elif farm_tile.atlas_choords == BASIL_SEED_POS:
			farm_tile.atlas_choords = BASIL_PLANT_POS
		elif farm_tile.atlas_choords in [POTATO_PLANT_POS, TOMATO_PLANT_POS, BASIL_PLANT_POS]:
			farm_tile.growing_days += 1
			if farm_tile.is_harvest_time():
				if farm_tile.plant_type == FarmTile.PlantType.POTATO:
					farm_tile.atlas_choords = POTATO_HARVEST_POS
				elif farm_tile.plant_type == FarmTile.PlantType.TOMATO:
					farm_tile.atlas_choords = TOMATO_HARVEST_POS
				elif farm_tile.plant_type == FarmTile.PlantType.BASIL:
					farm_tile.atlas_choords = BASIL_HARVEST_POS
				var surrounding_farm_tiles = get_surrounding_farm_tiles(farm_tile)
				farm_tile.determine_harvest_value(surrounding_farm_tiles)


func harvest(farm_tile: FarmTile):
	if farm_tile.plant_type == FarmTile.PlantType.POTATO:
		print("Potatoes harvested: ", farm_tile.harvest)
	elif farm_tile.plant_type == FarmTile.PlantType.TOMATO:
		print("Tomatoes harvested: ", farm_tile.harvest)
	elif farm_tile.plant_type == FarmTile.PlantType.BASIL:
		print("Basils harvested: ", farm_tile.harvest)
	farm_tile.reset()
