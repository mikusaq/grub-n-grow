extends Control

@export var crop_inventory: Inv
@onready var containers: Array = $CropList.get_children()


func _ready() -> void:
	crop_inventory.slot_changed.connect(update_slot)


func update_slot(slot_number: int):
	var new_amount: int = crop_inventory.slots[slot_number].amount
	containers[slot_number].get_node("AmountLabel").text = "x" + str(new_amount)
