extends Node2D


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)
