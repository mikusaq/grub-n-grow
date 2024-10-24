extends Resource

class_name Inv

@export var slots: Array[InvSlot]

signal slot_changed(slot_number: int)


# Adds item to inventory. Returns true on success, else false when inventory is full.
func add_item(item_to_add: InvItem, amount: int) -> bool:
	var first_empty_number: int = -1
	for i in range(slots.size()):
		if slots[i].is_empty() and first_empty_number == -1:
			first_empty_number = i
		if slots[i].item == item_to_add and slots[i].item.stackable:
			slots[i].add_item(item_to_add, amount)
			slot_changed.emit(i)
			return true
	
	if first_empty_number > -1:
		slots[first_empty_number].add_item(item_to_add, amount)
		slot_changed.emit(first_empty_number)
		return true
	
	return false


# Removes item from inventory. Returns true on success, else false when item is not in inventory.
func remove_item(item_to_remove: InvItem, amount: int) -> bool:
	for i in range(slots.size()):
		if slots[i].item == item_to_remove:
			slots[i].remove_item(item_to_remove, amount)
			slot_changed.emit(i)
			return true
	
	return false
