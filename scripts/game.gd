extends Node2D


func _ready() -> void:
	$HUD.set_money($Player.money)


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)
