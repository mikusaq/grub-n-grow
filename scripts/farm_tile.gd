class_name FarmTile extends Object

# Positions of general tiles in atlas
const SOIL_1_POS = Vector2i(3, 0)
const SOIL_2_POS = Vector2i(4, 0)
const GRASS_POS = Vector2i(4, 1)
const MULCH_POS = Vector2i(3, 1)
const SEED_POS = Vector2i(3, 2)
const TREE_POS = Vector2i(7, 0)

# Positions of plant specific tiles in atlas
const POTATO_POS = Vector2i(6, 0)
const TOMATO_POS = Vector2i(5, 0)
const BASIL_POS = Vector2i(5, 1)
const STRAWBERRY_POS = Vector2i(6, 1)
const GARLIC_POS = Vector2i(5, 2)
const PEA_POS = Vector2i(6, 2)

enum TileState {GRASS, SOIL_1, SOIL_2, MULCH, SEED, HARVEST}

signal change_tile(tile_pos: Vector2i, ground_pos: Vector2i, plant_pos: Vector2i)

var farm_grid: FarmGrid 
var tile_state: TileState = TileState.GRASS
var plant_type: Const.PlantType = Const.PlantType.NoType
var tile_pos: Vector2i
var harvest_value: int = 1


func is_harvestable() -> bool:
	if plant_type == Const.PlantType.BaseTree:
		return false
	return tile_state == TileState.HARVEST


func process_next_turn():
	if tile_state == TileState.SOIL_1:
		tile_state = TileState.GRASS
		_update_tile()
	elif tile_state == TileState.SEED:
		tile_state = TileState.HARVEST
		_update_tile()
		_determine_harvest_value()


func seed_plant(plant_to_seed: Const.PlantType):
	tile_state = TileState.SEED
	plant_type = plant_to_seed
	_update_tile()


func harvest(crop_inv: Inv):
	print(harvest_value)
	var inv_item: InvItem
	if plant_type == Const.PlantType.Potato:
		inv_item = preload("res://resources/inventory/items/crops/potato_item.tres")
	elif plant_type == Const.PlantType.Tomato:
		inv_item = preload("res://resources/inventory/items/crops/tomato_item.tres")
	elif plant_type == Const.PlantType.Basil:
		inv_item = preload("res://resources/inventory/items/crops/basil_item.tres")
	elif plant_type == Const.PlantType.Strawberry:
		inv_item = preload("res://resources/inventory/items/crops/strawberry_item.tres")
	elif plant_type == Const.PlantType.Garlic:
		inv_item = preload("res://resources/inventory/items/crops/garlic_item.tres")
	elif plant_type == Const.PlantType.Pea:
		inv_item = preload("res://resources/inventory/items/crops/pea_item.tres")
		crop_inv.add_item(inv_item, harvest_value)
		_reset(2)
		return
	crop_inv.add_item(inv_item, harvest_value)
	_reset()


func _update_tile():
	if tile_state == TileState.GRASS:
		change_tile.emit(tile_pos, GRASS_POS)
	elif tile_state == TileState.SOIL_1:
		change_tile.emit(tile_pos, SOIL_1_POS)
	elif tile_state == TileState.MULCH:
		change_tile.emit(tile_pos, SOIL_1_POS, MULCH_POS)
	elif tile_state == TileState.SEED:
		change_tile.emit(tile_pos, SOIL_1_POS, SEED_POS)
	elif tile_state == TileState.HARVEST:
		if plant_type == Const.PlantType.Potato:
			change_tile.emit(tile_pos, SOIL_1_POS, POTATO_POS)
		elif plant_type == Const.PlantType.Tomato:
			change_tile.emit(tile_pos, SOIL_1_POS, TOMATO_POS)
		elif plant_type == Const.PlantType.Basil:
			change_tile.emit(tile_pos, SOIL_1_POS, BASIL_POS)
		elif plant_type == Const.PlantType.Strawberry:
			change_tile.emit(tile_pos, SOIL_1_POS, STRAWBERRY_POS)
		elif plant_type == Const.PlantType.Garlic:
			change_tile.emit(tile_pos, SOIL_1_POS, GARLIC_POS)
		elif plant_type == Const.PlantType.Pea:
			change_tile.emit(tile_pos, SOIL_1_POS, PEA_POS)


func _reset(new_harvest_value: int = 1):
	tile_state = TileState.SOIL_1
	plant_type = Const.PlantType.NoType
	change_tile.emit(tile_pos, SOIL_1_POS)
	harvest_value = new_harvest_value


func _determine_harvest_value() -> void:
	var surrounding_farm_tiles = farm_grid.get_surrounding_farm_tiles(self)
	for farm_tile in surrounding_farm_tiles:
		if farm_tile.plant_type == Const.PlantType.BaseTree:
			harvest_value += 1
		elif farm_tile.plant_type == Const.PlantType.Basil and plant_type == Const.PlantType.Tomato:
			harvest_value += 1
		elif farm_tile.plant_type == Const.PlantType.Garlic and plant_type == Const.PlantType.Strawberry:
			harvest_value += 1
