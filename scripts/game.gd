extends Node2D


func _ready() -> void:
	$HUD.set_money($Player.money)


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_day"):
		if $World/FarmGrid.in_season:
			$World/FarmGrid.process_end_of_season()
		else:
			$World/FarmGrid.process_next_season()
