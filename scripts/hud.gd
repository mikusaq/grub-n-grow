extends CanvasLayer

var task_card_ui_scene = preload("res://scenes/ui/task_card_ui.tscn")
@export var crop_inv: Inv

signal add_money(money: int)


func _ready() -> void:
	crop_inv.slot_changed.connect(update_fulfill_conditions)


func set_money(money: int):
	$MoneyAmount.text = Const.MONEY_SYMBOL + str(money)


func set_task_cards(task_cards: Array[TaskCard]):
	for task_card in task_cards:
		var task_card_ui: TaskCardUI = task_card_ui_scene.instantiate()
		task_card_ui.set_task_card(task_card)
		task_card_ui.task_completed.connect(task_completed)
		$TaskContainer.add_child(task_card_ui)


func update_fulfill_conditions(slot_number: int) -> void:
	for task_card_ui: TaskCardUI in $TaskContainer.get_children():
		task_card_ui.update_fulfill_condition()


func task_completed(reward: int) -> void:
	add_money.emit(reward)
