class_name FarmGrid extends Node2D

const CHOORDS_MIN = 0
const CHOORDS_MAX = 4

const RED_VECTOR: Vector3 = Vector3(1.0, 0.0, 0.0)
const GREEN_VECTOR: Vector3 = Vector3(0.0, 1.0, 0.0)

@onready var tileMaterial: ShaderMaterial = load("res://shaders/farm_tile_shader_material.material")

var mulch_item: InvItem = preload("res://resources/inventory/items/mulch_item.tres")
var potato_seed_item: InvItem = preload("res://resources/inventory/items/seeds/potato_seed_item.tres")
var tomato_seed_item: InvItem = preload("res://resources/inventory/items/seeds/tomato_seed_item.tres")
var basil_seed_item: InvItem = preload("res://resources/inventory/items/seeds/basil_seed_item.tres")

var farm_tiles: Array[FarmTile]
var player_pos: Vector2 = Vector2.ZERO
var player_pos_changed: bool = false
var pixel_art_size: Vector2
var current_tile_pos: Vector2
var player_can_interact: bool = false
var in_season = true

@export var reach_distance: float = 60.0
@export var inv: PlayerInv


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_art_size = $Ground.tile_set.tile_size
	tileMaterial.set_shader_parameter("pixelArtSize", pixel_art_size.x)
	var all_ground_cells_pos: Array[Vector2i] = $Ground.get_used_cells()
	var all_plants_cells_pos: Array[Vector2i] = $OnGround.get_used_cells()
	var it = 0
	for tile_pos in all_ground_cells_pos:
		var farm_tile = FarmTile.new()
		farm_tile.farm_grid = self
		farm_tile.tile_pos = tile_pos
		var atlas_choords = $OnGround.get_cell_atlas_coords(tile_pos)
		if atlas_choords == FarmTile.TREE_POS:
			farm_tile.plant_type = Const.PlantType.BaseTree
			
		farm_tile.change_tile.connect(_update_tile_atlas_choords)
		farm_tiles.append(farm_tile)


func _process(delta):
	if current_tile_pos != get_tile_global_pos() or player_pos_changed:
		current_tile_pos = get_tile_global_pos()
		player_pos_changed = false
		update_interaction_with_player()
		$OnGround.notify_runtime_tile_data_update()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = $Ground.local_to_map(mouse_pos)
		if tile_in_farm_grid(tile_mouse_pos):
			var farm_tile = get_farm_tile(tile_mouse_pos)
			process_click_on_farm_tile(farm_tile)


func set_player_pos(pos: Vector2):
	player_pos = pos
	if player_pos.x < 0 or player_pos.y < 0:
		$OnGround.player_tile_pos = Vector2i(-1, -1)
	else:
		$OnGround.player_tile_pos = Vector2i(pos) / pixel_art_size.x
	player_pos_changed = true


func get_farm_tile(tile_pos: Vector2i) -> FarmTile:
	for farm_tile in farm_tiles:
		if farm_tile.tile_pos == tile_pos:
			return farm_tile
	return null


func get_surrounding_farm_tiles(farm_tile: FarmTile) -> Array[FarmTile]:
	var farm_tiles: Array[FarmTile]
	var surrounding_cells = $OnGround.get_surrounding_cells(farm_tile.tile_pos)
	for cell in surrounding_cells:
		if tile_in_farm_grid(cell):
			farm_tiles.append(get_farm_tile(cell))
	return farm_tiles


func tile_in_farm_grid(farm_tile_pos: Vector2i) -> bool:
	if (farm_tile_pos.x >= CHOORDS_MIN and farm_tile_pos.x <= CHOORDS_MAX
	and farm_tile_pos.y >= CHOORDS_MIN and farm_tile_pos.y <= CHOORDS_MAX):
		return true
	return false


func trim_float_to_multiple_of_base(num: float, base: int) -> float:
	return num - fposmod(num, base)


func get_tile_global_pos() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var mouseX = trim_float_to_multiple_of_base(mouse_pos.x, pixel_art_size.x)
	var mouseY = trim_float_to_multiple_of_base(mouse_pos.y, pixel_art_size.y)
	return Vector2(mouseX, mouseY)


func update_interaction_with_player():
	if (current_tile_pos.x >= CHOORDS_MIN and current_tile_pos.x <= CHOORDS_MAX * pixel_art_size.x 
	and current_tile_pos.y >= CHOORDS_MIN and current_tile_pos.y <= CHOORDS_MAX * pixel_art_size.y):
		var current_tile_pos_center = Vector2(current_tile_pos.x + (pixel_art_size.x/2), current_tile_pos.y + (pixel_art_size.y/2))
		if current_tile_pos_center.distance_to(player_pos) > reach_distance:
			tileMaterial.set_shader_parameter("highlightColor", RED_VECTOR)
			player_can_interact = false
		else:
			tileMaterial.set_shader_parameter("highlightColor", GREEN_VECTOR)
			player_can_interact = true
		tileMaterial.set_shader_parameter("globalTilePos", current_tile_pos)
	else:
		tileMaterial.set_shader_parameter("globalTilePos", -pixel_art_size)


func process_click_on_farm_tile(farm_tile: FarmTile):
	var active_item = inv.get_active_item()
	if player_can_interact and active_item != null:
		if active_item.name == "Scythe":
			if farm_tile.tile_state == FarmTile.TileState.GRASS:
				if farm_tile.plant_type != Const.PlantType.BaseTree:
					farm_tile.tile_state = FarmTile.TileState.SOIL_1
					_update_tile_atlas_choords(farm_tile.tile_pos, FarmTile.SOIL_1_POS)
					inv.add_item(mulch_item, 1)
			elif farm_tile.is_harvestable():
				farm_tile.harvest()
		elif active_item.name == "Mulch":
			if farm_tile.tile_state == FarmTile.TileState.SOIL_1:
				farm_tile.tile_state = FarmTile.TileState.MULCH
				_update_tile_atlas_choords(farm_tile.tile_pos, FarmTile.SOIL_1_POS, FarmTile.MULCH_POS)
				inv.remove_item(mulch_item, 1)
		elif active_item.name in ["Potato seed", "Tomato seed", "Basil seed"]:
			if farm_tile.tile_state == FarmTile.TileState.MULCH:
				var plant_to_seed: Const.PlantType
				if active_item.name == "Potato seed":
					plant_to_seed = Const.PlantType.Potato
					inv.remove_item(potato_seed_item, 1)
				elif active_item.name == "Tomato seed":
					plant_to_seed = Const.PlantType.Tomato
					inv.remove_item(tomato_seed_item, 1)
				elif active_item.name == "Basil seed":
					plant_to_seed = Const.PlantType.Basil
					inv.remove_item(basil_seed_item, 1)
				farm_tile.seed_plant(plant_to_seed)


func _update_tile_atlas_choords(tile_pos: Vector2i, ground_pos: Vector2i, plant_pos: Vector2i = Vector2i(-1, -1)):
	assert(tile_pos != null)
	assert(ground_pos != null)
	$Ground.set_cell(tile_pos, 0, ground_pos)
	$OnGround.set_cell(tile_pos, 0, plant_pos)


func process_end_of_season():
	for farm_tile in farm_tiles:
		farm_tile.process_end_of_season()


func process_next_season():
	for farm_tile in farm_tiles:
		farm_tile.process_next_season()
