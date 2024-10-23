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
		slots[i].update(inv.slots[i])


func change_active_slot(slot_number :int):
	slots[active_slot].set_highlight_visibility(false)
	active_slot = slot_number
	slots[active_slot].set_highlight_visibility(true)
	
