extends Node2D


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _on_player_active_slot_changed(new_slot_number: int, active_item: InvItem) -> void:
	$HUD/InventoryUI.change_active_slot(new_slot_number)
	$World/FarmGrid.set_active_item(active_item)


func _on_player_slot_changed(slot_number: int) -> void:
	$HUD/InventoryUI.update_slot(slot_number)
