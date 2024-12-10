extends Resource

class_name InvSlot

@export var item: InvItem = null
@export var amount: int = 0


func is_empty() -> bool:
	return item == null


func add_item(item_to_add: InvItem, item_amount: int):
	if !item:
		item = item_to_add
		if item.stackable:
			amount = item_amount
	else:
		assert(item_to_add == item)
		assert(item.stackable)
		amount += item_amount


func remove_item(item_to_remove: InvItem, item_amount: int):
	assert(item)
	if amount > item_amount and item.stackable:
		amount -= item_amount
	else:
		amount = 0
