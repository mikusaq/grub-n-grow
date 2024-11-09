extends Resource

class_name TaskCard

@export var name: String
@export var tasks: Array[Task]
@export var reward: int

var crop_inv: Inv = preload("res://resources/inventory/crop_inventory.tres")


func condition_fulfilled() -> bool:
	for task in tasks:
		if not crop_inv.has_item(task.item, task.amount):
			return false
	return true


func fulfill_task() -> bool:
	if not condition_fulfilled():
		return false
	
	for task in tasks:
		crop_inv.remove_item(task.item, task.amount)
	
	return true
