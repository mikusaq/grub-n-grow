extends Resource

class_name TaskCard

@export var name: String
@export var tasks: Array[Task]
@export var reward: int


func condition_fulfilled(crop_inv: Inv) -> bool:
	for task in tasks:
		if not crop_inv.has_item(task.item, task.amount):
			return false
	return true
