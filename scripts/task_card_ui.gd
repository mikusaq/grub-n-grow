extends Control

var task_card: TaskCard

signal task_completed(task_card: TaskCard)


func set_task_card(new_task_card: TaskCard) -> void:
	task_card = new_task_card
	$Name.text = task_card.name
	var tasks_str: String = ""
	for task in task_card.tasks:
		tasks_str += str(task.amount) + "x " + task.item.name + "\n"
	$Tasks.text = tasks_str
	$CompleteButton/MoneyAmount.text = Const.MONEY_SYMBOL + str(task_card.reward)


func update_fulfill_condition(crop_inv: Inv) -> void:
	if task_card.condition_fulfilled(crop_inv):
		$CompleteButton.disabled = false


func _on_complete_button_pressed() -> void:
	task_completed.emit(task_card)
