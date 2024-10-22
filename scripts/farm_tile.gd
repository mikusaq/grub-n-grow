class_name FarmTile extends Object

# Positions of general tiles in atlas
const SOIL_1_POS = Vector2i(3, 0)
const SOIL_2_POS = Vector2i(4, 0)
const GRASS_POS = Vector2i(4, 1)
const MULCH_POS = Vector2i(0, 3)
const SEED_POS = Vector2i(1, 3)
const TREE_POS = Vector2i(4, 2)

# Positions of plant specific tiles in atlas
const SPROUT_POS = Vector2i(2, 3)
const POTATO_POS = Vector2i(3, 2)
const TOMATO_POS = Vector2i(3, 1)
const BASIL_POS = Vector2i(3, 3)

# Grow days of plants
const POTATO_GROW_DAYS = 2
const TOMATO_GROW_DAYS = 3
const BASIL_GROW_DAYS = 3

enum TileState {GRASS, SOIL_1, SOIL_2, MULCH, SEED, SPROUT, HARVEST}
enum PlantType {NO_TYPE, POTATO, TOMATO, BASIL, TREE}

signal change_tile(tile_pos: Vector2i, ground_pos: Vector2i, plant_pos: Vector2i)

var farm_grid: FarmGrid 
var tile_state: TileState = TileState.GRASS
var plant_type: PlantType = PlantType.NO_TYPE
var tile_pos: Vector2i
var growing_days: int = 0
var harvest_value: int = 1


func is_harvestable() -> bool:
	return tile_state == TileState.HARVEST


func process_next_day():
	if tile_state == TileState.SEED:
		tile_state = TileState.SPROUT
		_update_tile()
	elif tile_state == TileState.SPROUT:
		growing_days += 1
		if _is_harvest_time():
			tile_state = TileState.HARVEST
			_update_tile()
			var surrounding_farm_tiles = farm_grid.get_surrounding_farm_tiles(self)
			_determine_harvest_value(surrounding_farm_tiles)


func seed_plant(plant_to_seed: PlantType):
	tile_state = TileState.SEED
	plant_type = plant_to_seed
	_update_tile()


func harvest():
	if plant_type == PlantType.POTATO:
		print("Potatoes harvested: ", harvest_value)
	elif plant_type == PlantType.TOMATO:
		print("Tomatoes harvested: ", harvest_value)
	elif plant_type == PlantType.BASIL:
		print("Basils harvested: ", harvest_value)
	_reset()


func _update_tile():
	if tile_state == TileState.GRASS:
		change_tile.emit(tile_pos, GRASS_POS, null)
	elif tile_state == TileState.SOIL_1:
		change_tile.emit(tile_pos, SOIL_1_POS, null)
	elif tile_state == TileState.MULCH:
		change_tile.emit(tile_pos, SOIL_1_POS, MULCH_POS)
	elif tile_state == TileState.SEED:
		change_tile.emit(tile_pos, SOIL_1_POS, SEED_POS)
	elif tile_state == TileState.SPROUT:
		change_tile.emit(tile_pos, SOIL_1_POS, SPROUT_POS)
	elif tile_state == TileState.HARVEST:
		if plant_type == PlantType.POTATO:
			change_tile.emit(tile_pos, SOIL_1_POS, POTATO_POS)
		elif plant_type == PlantType.TOMATO:
			change_tile.emit(tile_pos, SOIL_1_POS, TOMATO_POS)
		elif plant_type == PlantType.BASIL:
			change_tile.emit(tile_pos, SOIL_1_POS, BASIL_POS)


func _reset():
	tile_state = TileState.SOIL_1
	plant_type = PlantType.NO_TYPE
	change_tile.emit(tile_pos, SOIL_1_POS, Vector2i(-1, -1))
	growing_days = 0
	harvest_value = 1


func _is_harvest_time() -> bool:
	if plant_type == PlantType.POTATO:
		if growing_days == POTATO_GROW_DAYS:
			return true
	elif plant_type == PlantType.TOMATO:
		if growing_days == TOMATO_GROW_DAYS:
			return true
	elif plant_type == PlantType.BASIL:
		if growing_days == BASIL_GROW_DAYS:
			return true
	return false


func _determine_harvest_value(surrounding_farm_tiles: Array[FarmTile]) -> void:
	for farm_tile in surrounding_farm_tiles:
		if farm_tile.plant_type == PlantType.TREE:
			harvest_value += 1
		elif farm_tile.plant_type == PlantType.BASIL and plant_type == PlantType.TOMATO:
			harvest_value += 1
