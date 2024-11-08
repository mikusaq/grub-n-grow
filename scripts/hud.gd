extends CanvasLayer

const money_symbol = "$"

var task_card_ui_scene = preload("res://scenes/ui/task_card_ui.tscn")


func set_money(money: int):
	$MoneyAmount.text = money_symbol + str(money)


func set_task_cards(task_cards: Array[TaskCard]):
	for task_card in task_cards:
		var task_card_ui = task_card_ui_scene.instantiate()
		task_card_ui.get_node("Name").text = task_card.name
		var tasks_str: String = ""
		for task in task_card.tasks:
			tasks_str += str(task.amount) + "x " + Enums.PlantType.keys()[task.plant_type] + "\n"
		task_card_ui.get_node("Tasks").text = tasks_str
		task_card_ui.get_node("CompleteButton/MoneyAmount").text = money_symbol + str(task_card.reward)
		$TaskContainer.add_child(task_card_ui)
		
