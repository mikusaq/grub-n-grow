class_name FarmTile extends Object

# Positions of plant specific tiles in atlas
const POTATO_SEED_POS = Vector2i(0, 1)
const POTATO_PLANT_POS = Vector2i(1, 1)
const POTATO_HARVEST_POS = Vector2i(2, 1)
const TOMATO_SEED_POS = Vector2i(0, 2)
const TOMATO_PLANT_POS = Vector2i(1, 2)
const TOMATO_HARVEST_POS = Vector2i(2, 2)
const BASIL_SEED_POS = Vector2i(0, 3)
const BASIL_PLANT_POS = Vector2i(1, 3)
const BASIL_HARVEST_POS = Vector2i(2, 3)

# Grow days of plants
const POTATO_GROW_DAYS = 2
const TOMATO_GROW_DAYS = 3
const BASIL_GROW_DAYS = 3

enum PlantType {NO_TYPE, POTATO, TOMATO, BASIL, TREE}


var farm_grid: FarmGrid
var plant_type: PlantType = PlantType.NO_TYPE
var tile_pos: Vector2i
var atlas_choords: Vector2i:
	set(new_value):
		atlas_choords = new_value
		farm_grid.set_cell(tile_pos, 0, atlas_choords)
var growing_days: int = 0
var harvest_value: int = 1


func is_harvestable() -> bool:
	if atlas_choords in [POTATO_HARVEST_POS, TOMATO_HARVEST_POS, BASIL_HARVEST_POS]:
		return true
	return false


func process_next_day():
	if atlas_choords == POTATO_SEED_POS:
		atlas_choords = POTATO_PLANT_POS
	elif atlas_choords == TOMATO_SEED_POS:
		atlas_choords = TOMATO_PLANT_POS
	elif atlas_choords == BASIL_SEED_POS:
		atlas_choords = BASIL_PLANT_POS
	elif atlas_choords in [POTATO_PLANT_POS, TOMATO_PLANT_POS, BASIL_PLANT_POS]:
		growing_days += 1
		if _is_harvest_time():
			if plant_type == PlantType.POTATO:
				atlas_choords = POTATO_HARVEST_POS
			elif plant_type == FarmTile.PlantType.TOMATO:
				atlas_choords = TOMATO_HARVEST_POS
			elif plant_type == FarmTile.PlantType.BASIL:
				atlas_choords = BASIL_HARVEST_POS
			var surrounding_farm_tiles = farm_grid.get_surrounding_farm_tiles(self)
			_determine_harvest_value(surrounding_farm_tiles)


func seed_plant(plant_to_seed: PlantType):
	plant_type = plant_to_seed
	if plant_to_seed == PlantType.POTATO:
		atlas_choords = POTATO_PLANT_POS
	elif plant_to_seed == PlantType.TOMATO:
		atlas_choords = TOMATO_PLANT_POS
	elif plant_to_seed == PlantType.BASIL:
		atlas_choords = BASIL_PLANT_POS


func harvest():
	if plant_type == PlantType.POTATO:
		print("Potatoes harvested: ", harvest_value)
	elif plant_type == PlantType.TOMATO:
		print("Tomatoes harvested: ", harvest_value)
	elif plant_type == PlantType.BASIL:
		print("Basils harvested: ", harvest_value)
	_reset()


func _reset(new_atlas_choords: Vector2i = FarmGrid.SOIL_POS):
	plant_type = PlantType.NO_TYPE
	atlas_choords = new_atlas_choords
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
