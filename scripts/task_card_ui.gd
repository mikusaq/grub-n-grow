extends Control

class_name TaskCardUI

var task_card: TaskCard
var tween: Tween

signal task_completed(task: TaskCard)

func _ready() -> void:
	modulate.a = 0.0
	await get_tree().create_timer(0.1).timeout
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)


func set_task_card(new_task_card: TaskCard) -> void:
	task_card = new_task_card
	$Name.text = task_card.name
	var tasks_str: String = ""
	for task in task_card.tasks:
		tasks_str += str(task.amount) + "x " + task.item.name + "\n"
	$Tasks.text = tasks_str
	$CompleteButton.text = Const.MONEY_SYMBOL + str(task_card.reward)


func update_fulfill_condition() -> void:
	$CompleteButton.disabled = not task_card.condition_fulfilled()


func _on_complete_button_pressed() -> void:
	$CompleteButton.disabled = true
	if task_card.fulfill_task():
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		await tween.finished
		task_completed.emit(task_card)
		queue_free()
