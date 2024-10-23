extends Node2D


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _on_player_active_slot_changed(new_slot_number: int) -> void:
	$HUD/InventoryUI.change_active_slot(new_slot_number)
