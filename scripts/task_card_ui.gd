extends Control

var task_card: TaskCard

func set_task_card(new_task_card: TaskCard) -> void:
	task_card = new_task_card
	$Name.text = task_card.name
	var tasks_str: String = ""
	for task in task_card.tasks:
		tasks_str += str(task.amount) + "x " + Const.PlantType.keys()[task.plant_type] + "\n"
	$Tasks.text = tasks_str
	$CompleteButton/MoneyAmount.text = Const.MONEY_SYMBOL + str(task_card.reward)
