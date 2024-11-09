extends CanvasLayer

var task_card_ui_scene = preload("res://scenes/ui/task_card_ui.tscn")


func set_money(money: int):
	$MoneyAmount.text = Const.MONEY_SYMBOL + str(money)


func set_task_cards(task_cards: Array[TaskCard]):
	for task_card in task_cards:
		var task_card_ui = task_card_ui_scene.instantiate()
		task_card_ui.set_task_card(task_card)
		$TaskContainer.add_child(task_card_ui)
		
