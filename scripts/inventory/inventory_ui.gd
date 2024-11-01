extends Control

@export var inv: Inv
@onready var slots: Array = $GridContainer.get_children()
var active_slot: int


func _ready():
	update_slots()
	active_slot = 0
	slots[active_slot].set_highlight_visibility(true)


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		update_slot(i)


func update_slot(slot_number: int):
	slots[slot_number].update(inv.slots[slot_number])


func change_active_slot(slot_number: int):
	slots[active_slot].set_highlight_visibility(false)
	active_slot = slot_number
	slots[active_slot].set_highlight_visibility(true)
	
