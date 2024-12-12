extends Inv

class_name PlayerInv

var active_slot: int = 0:
	get:
		return active_slot
	set(new_active_slot):
		active_slot = new_active_slot
		active_slot_changed.emit()

signal active_slot_changed()


func get_active_slot() -> InvSlot:
	return slots[active_slot]
