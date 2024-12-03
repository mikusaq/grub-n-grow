extends Node2D

var player_in_door_area: bool = false

@export var active_door_color: Color
@export var inactive_door_color: Color
@export var pressed_door_color: Color

signal next_turn
signal work_on_farm_grid


func _set_button_color(hover_color: Color, pressed_color: Color):
	var style_box: StyleBoxFlat = $Door/NextTurnButton.get_theme_stylebox("hover")
	style_box.bg_color = hover_color
	style_box = $Door/NextTurnButton.get_theme_stylebox("pressed")
	style_box.bg_color = pressed_color


func _on_door_area_body_entered(body: Node2D) -> void:
	player_in_door_area = true
	_set_button_color(active_door_color, pressed_door_color)


func _on_door_area_body_exited(body: Node2D) -> void:
	player_in_door_area = false
	_set_button_color(inactive_door_color, inactive_door_color)


func _on_next_turn_button_pressed() -> void:
	if player_in_door_area:
		next_turn.emit()


func _on_farm_grid_working() -> void:
	work_on_farm_grid.emit()
