class_name FarmTile extends Object

# Positions of general tiles in atlas
const SOIL_1_POS = Vector2i(3, 0)
const SOIL_2_POS = Vector2i(4, 0)
const GRASS_POS = Vector2i(4, 1)
const MULCH_POS = Vector2i(3, 1)
const SEED_POS = Vector2i(3, 2)
const SPROUT_POS = Vector2i(4, 2)
const TREE_POS = Vector2i(7, 0)

# Positions of plant specific tiles in atlas
const POTATO_POS = Vector2i(6, 0)
const TOMATO_POS = Vector2i(5, 0)
const BASIL_POS = Vector2i(5, 1)
const STRAWBERRY_POS = Vector2i(6, 1)
const STRAWBERRY_HARVESTED_POS = Vector2i(7, 2)
const GARLIC_POS = Vector2i(5, 2)
const PEA_POS = Vector2i(6, 2)
const APPLE_POS = Vector2i(8, 0)
const APPLE_HARVESTED_POS = Vector2i(9, 0)

const STRAWBERRY_LAST_TIME = 3
const APPLE_TREE_GROW_TIME = 3
const APPLE_TREE_RIPE_TIME = 3


enum TileState {GRASS, SOIL_1, SOIL_2, MULCH, SEED, SPROUT, PLANT, HARVEST}

signal change_tile(tile_pos: Vector2i, ground_pos: Vector2i, plant_pos: Vector2i)

var farm_grid: FarmGrid
var tile_state: TileState = TileState.GRASS
var plant_type: Const.PlantType = Const.PlantType.NoType
var tile_pos: Vector2i
var harvest_value: int = 1
var growing_day: int = 0
var since_harvest: int = 0


func is_harvestable() -> bool:
	if plant_type == Const.PlantType.BaseTree:
		return false
	return tile_state == TileState.HARVEST


func is_fully_grown_tree() -> bool:
	if plant_type == Const.PlantType.BaseTree:
		return true
	return is_fully_grown_apple_tree()


func is_fully_grown_apple_tree() -> bool:
	if plant_type == Const.PlantType.Apple and growing_day >= APPLE_TREE_GROW_TIME:
		return true
	return false


func process_next_turn():
	if tile_state in [TileState.SOIL_1, TileState.SOIL_2]:
		tile_state = TileState.GRASS
		_update_tile()
	elif tile_state == TileState.SEED:
		if plant_type == Const.PlantType.Apple:
			tile_state = TileState.SPROUT
			harvest_value = 1
			_update_tile()
			return
		growing_day += 1
		tile_state = TileState.HARVEST
		_update_tile()
		_determine_harvest_value()
	elif tile_state == TileState.SPROUT:
		growing_day += 1
		if plant_type == Const.PlantType.Apple and growing_day == APPLE_TREE_GROW_TIME:
			tile_state = TileState.PLANT
			_update_tile()
	elif tile_state == TileState.PLANT:
		growing_day += 1
		since_harvest += 1
		if plant_type == Const.PlantType.Apple:
			if since_harvest == APPLE_TREE_RIPE_TIME:
				tile_state = TileState.HARVEST
		elif plant_type == Const.PlantType.Strawberry:
			tile_state = TileState.HARVEST
		_update_tile()


func seed_plant(plant_to_seed: Const.PlantType):
	tile_state = TileState.SEED
	plant_type = plant_to_seed
	_update_tile()


func harvest(crop_inv: Inv):
	var inv_item: InvItem
	if plant_type == Const.PlantType.Potato:
		inv_item = preload("res://resources/inventory/items/crops/potato_item.tres")
	elif plant_type == Const.PlantType.Tomato:
		inv_item = preload("res://resources/inventory/items/crops/tomato_item.tres")
	elif plant_type == Const.PlantType.Basil:
		inv_item = preload("res://resources/inventory/items/crops/basil_item.tres")
	elif plant_type == Const.PlantType.Strawberry:
		inv_item = preload("res://resources/inventory/items/crops/strawberry_item.tres")
		if growing_day < STRAWBERRY_LAST_TIME:
			add_harvest_to_inv(inv_item, crop_inv)
			tile_state = TileState.PLANT
			change_tile.emit(tile_pos, SOIL_1_POS, STRAWBERRY_HARVESTED_POS)
			harvest_value = 1
			return
	elif plant_type == Const.PlantType.Garlic:
		inv_item = preload("res://resources/inventory/items/crops/garlic_item.tres")
	elif plant_type == Const.PlantType.Pea:
		inv_item = preload("res://resources/inventory/items/crops/pea_item.tres")
		add_harvest_to_inv(inv_item, crop_inv)
		tile_state = TileState.SOIL_2
		plant_type = Const.PlantType.NoType
		change_tile.emit(tile_pos, SOIL_2_POS)
		harvest_value = 2
		since_harvest = 0
		return
	elif plant_type == Const.PlantType.Apple:
		inv_item = preload("res://resources/inventory/items/crops/apple_item.tres")
		add_harvest_to_inv(inv_item, crop_inv)
		tile_state = TileState.PLANT
		change_tile.emit(tile_pos, SOIL_1_POS, APPLE_HARVESTED_POS)
		harvest_value = 1
		since_harvest = 0
		return
	
	add_harvest_to_inv(inv_item, crop_inv)
	reset()


func add_harvest_to_inv(inv_item: InvItem, crop_inv: Inv) -> void:
	crop_inv.add_item(inv_item, harvest_value)
	var text = preload("res://scenes/ui/spawn_text.tscn").instantiate()
	text.text = "+" + str(harvest_value)
	text.position = farm_grid.get_global_mouse_position()
	farm_grid.add_child(text)


func _update_tile():
	if tile_state == TileState.GRASS:
		change_tile.emit(tile_pos, GRASS_POS)
	elif tile_state == TileState.SOIL_1:
		change_tile.emit(tile_pos, SOIL_1_POS)
	elif tile_state == TileState.MULCH:
		change_tile.emit(tile_pos, SOIL_1_POS, MULCH_POS)
	elif tile_state == TileState.SEED:
		change_tile.emit(tile_pos, SOIL_1_POS, SEED_POS)
	elif tile_state == TileState.SPROUT:
		if plant_type == Const.PlantType.Apple:
			change_tile.emit(tile_pos, SOIL_1_POS, SPROUT_POS)
	elif tile_state == TileState.PLANT:
		if plant_type == Const.PlantType.Apple:
			change_tile.emit(tile_pos, SOIL_1_POS, APPLE_HARVESTED_POS)
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
		elif plant_type == Const.PlantType.Apple:
			change_tile.emit(tile_pos, SOIL_1_POS, APPLE_POS)


func reset(new_harvest_value: int = 1):
	tile_state = TileState.SOIL_1
	plant_type = Const.PlantType.NoType
	change_tile.emit(tile_pos, SOIL_1_POS)
	harvest_value = new_harvest_value
	since_harvest = 0


func _determine_harvest_value() -> void:
	var surrounding_farm_tiles = farm_grid.get_surrounding_farm_tiles(self)
	var bonus_tree = false
	var apple_bonus_tree = false
	for farm_tile in surrounding_farm_tiles:
		if farm_tile.is_fully_grown_tree():
			if not bonus_tree:
				harvest_value += 1
				bonus_tree = true
			if is_fully_grown_apple_tree():
				var flowering_crops = [Const.PlantType.Tomato, Const.PlantType.Pea, Const.PlantType.Strawberry, Const.PlantType.Garlic]
				if plant_type in flowering_crops and not apple_bonus_tree:
					harvest_value += 1
					apple_bonus_tree = true
		elif farm_tile.plant_type == Const.PlantType.Basil and plant_type == Const.PlantType.Tomato:
			harvest_value += 1
		elif farm_tile.plant_type == Const.PlantType.Garlic and plant_type == Const.PlantType.Strawberry:
			harvest_value += 1
