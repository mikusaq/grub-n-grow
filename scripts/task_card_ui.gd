extends Control

class_name TaskCardUI

var task_card: TaskCard

signal task_completed(reward: int)


func set_task_card(new_task_card: TaskCard) -> void:
	task_card = new_task_card
	$Name.text = task_card.name
	var tasks_str: String = ""
	for task in task_card.tasks:
		tasks_str += str(task.amount) + "x " + task.item.name + "\n"
	$Tasks.text = tasks_str
	$CompleteButton.text = Const.MONEY_SYMBOL + str(task_card.reward)


func update_fulfill_condition() -> void:
	if task_card.condition_fulfilled():
		$CompleteButton.disabled = false


func _on_complete_button_pressed() -> void:
	$CompleteButton.disabled = true
	if task_card.fulfill_task():
		task_completed.emit(task_card.reward)
		queue_free()
