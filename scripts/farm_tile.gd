class_name FarmTile extends Object

enum PlantType {NO_TYPE, POTATO, TOMATO, BASIL, TREE}


var farm_grid: FarmGrid
var plant_type: PlantType = PlantType.NO_TYPE
var tile_pos: Vector2i
var atlas_choords: Vector2i:
	set(new_value):
		atlas_choords = new_value
		farm_grid.set_cell(tile_pos, 0, atlas_choords)
var growing_days: int = 0
var harvest: int = 1


func reset(new_atlas_choords: Vector2i = FarmGrid.SOIL_POS):
	plant_type = PlantType.NO_TYPE
	atlas_choords = new_atlas_choords
	growing_days = 0
	harvest = 1


func seed_plant(plant_to_seed: PlantType):
	plant_type = plant_to_seed
	if plant_to_seed == PlantType.POTATO:
		atlas_choords = FarmGrid.POTATO_PLANT_POS
	elif plant_to_seed == PlantType.TOMATO:
		atlas_choords = FarmGrid.TOMATO_PLANT_POS
	elif plant_to_seed == PlantType.BASIL:
		atlas_choords = FarmGrid.BASIL_PLANT_POS


func is_harvest_time() -> bool:
	if plant_type == PlantType.POTATO:
		if growing_days == 2:
			return true
	elif plant_type == PlantType.TOMATO:
		if growing_days == 3:
			return true
	elif plant_type == PlantType.BASIL:
		if growing_days == 3:
			return true
	return false
	
	
func determine_harvest_value(surrounding_farm_tiles: Array[FarmTile]) -> void:
	for farm_tile in surrounding_farm_tiles:
		if farm_tile.plant_type == PlantType.TREE:
			harvest += 1
		elif farm_tile.plant_type == PlantType.BASIL and plant_type == PlantType.TOMATO:
			harvest += 1
