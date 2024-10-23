extends Control

@onready var inv: Inv = preload("res://resources/inventory/player_inventory.tres")
@onready var slots: Array = $GridContainer.get_children()

func _ready():
	update_slots()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
