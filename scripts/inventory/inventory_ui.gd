extends Control

@export var inv: PlayerInv
@onready var slots: Array = $InventorySlots.get_children()
var active_slot: int


func _ready():
	update_slots()
	active_slot = inv.active_slot
	slots[active_slot].set_highlight_visibility(true)
	inv.active_slot_changed.connect(change_active_slot)
	inv.slot_changed.connect(update_slot)


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		update_slot(i)


func update_slot(slot_number: int):
	slots[slot_number].update(inv.slots[slot_number])


func change_active_slot():
	slots[active_slot].set_highlight_visibility(false)
	active_slot = inv.active_slot
	slots[active_slot].set_highlight_visibility(true)
	
