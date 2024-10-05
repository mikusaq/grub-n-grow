class_name FarmGrid extends TileMapLayer

# Positions of general tiles in atlas
const GRASS_POS = Vector2i(0, 0)
const SOIL_POS = Vector2i(1, 0)
const MULCH_POS = Vector2i(2, 0)
const TREE_POS = Vector2i(3, 0)

const CHOORDS_MIN = 0
const CHOORDS_MAX = 4

const RED_VECTOR: Vector3 = Vector3(0.6, 0.0, 0.0)
const GREEN_VECTOR: Vector3 = Vector3(0.0, 0.6, 0.0)

signal seed_chosen(plant_type: FarmTile.PlantType)

@onready var tileMaterial: ShaderMaterial = load("res://shaders/farm_tile_shader_material.material")

var farm_tiles: Array[FarmTile]
var player_pos: Vector2 = Vector2.ZERO
var player_pos_changed: bool = false
var pixel_art_size: Vector2
var current_tile_pos: Vector2
var player_can_interact: bool = false

@export var reach_distance: float = 60.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_art_size = self.tile_set.tile_size
	tileMaterial.set_shader_parameter("pixelArtSize", pixel_art_size.x)
	var all_cells_pos : Array[Vector2i] = get_used_cells()
	for tile_pos in all_cells_pos:
		var farm_tile = FarmTile.new()
		farm_tile.farm_grid = self
		farm_tile.tile_pos = tile_pos
		farm_tile.atlas_choords = get_cell_atlas_coords(tile_pos)
		if farm_tile.atlas_choords == TREE_POS:
			farm_tile.plant_type = FarmTile.PlantType.TREE
		farm_tiles.append(farm_tile)


func _process(delta):
	if current_tile_pos != get_tile_global_pos() or player_pos_changed:
		current_tile_pos = get_tile_global_pos()
		player_pos_changed = false
		update_interaction_with_player()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = local_to_map(mouse_pos)
		if tile_in_farm_grid(tile_mouse_pos):
			var farm_tile = get_farm_tile(tile_mouse_pos)
			process_click_on_farm_tile(farm_tile)
	elif event.is_action_pressed("1"):
		seed_chosen.emit(FarmTile.PlantType.POTATO)
	elif event.is_action_pressed("2"):
		seed_chosen.emit(FarmTile.PlantType.TOMATO)
	elif event.is_action_pressed("3"):
		seed_chosen.emit(FarmTile.PlantType.BASIL)
	elif event.is_action_pressed("next_day"):
		process_next_day()


func set_player_pos(pos: Vector2):
	player_pos = pos
	player_pos_changed = true


func get_farm_tile(tile_pos: Vector2i) -> FarmTile:
	for farm_tile in farm_tiles:
		if farm_tile.tile_pos == tile_pos:
			return farm_tile
	return null


func get_surrounding_farm_tiles(farm_tile: FarmTile) -> Array[FarmTile]:
	var farm_tiles: Array[FarmTile]
	var surrounding_cells = get_surrounding_cells(farm_tile.tile_pos)
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
	if player_can_interact:
		if farm_tile.atlas_choords == GRASS_POS:
			farm_tile.atlas_choords = SOIL_POS
		elif farm_tile.atlas_choords == SOIL_POS:
			farm_tile.atlas_choords = MULCH_POS
		elif farm_tile.atlas_choords == MULCH_POS:
			var plant_to_seed = await seed_chosen
			farm_tile.seed_plant(plant_to_seed)
		elif farm_tile.is_harvestable():
			farm_tile.harvest()


func process_next_day():
	for farm_tile in farm_tiles:
		farm_tile.process_next_day()
