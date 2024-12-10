extends CanvasLayer

var task_card_ui_scene = preload("res://scenes/ui/task_card_ui.tscn")
var crop_inv: Inv = load("res://resources/inventory/crop_inventory.tres")

signal task_completed(task: TaskCard)
signal enable_game
signal restart_game


func _ready() -> void:
	crop_inv.slot_changed.connect(update_fulfill_conditions)


func set_money(money: int):
	$MoneyAmount.text = Const.MONEY_SYMBOL + str(money)


func add_task_cards(task_cards: Array[TaskCard]):
	for task_card in task_cards:
		var task_card_ui: TaskCardUI = task_card_ui_scene.instantiate()
		task_card_ui.set_task_card(task_card)
		task_card_ui.task_completed.connect(complete_task)
		task_card_ui.update_fulfill_condition()
		$TaskContainer.add_child(task_card_ui)


func update_fulfill_conditions(slot_number: int) -> void:
	for task_card_ui: TaskCardUI in $TaskContainer.get_children():
		task_card_ui.update_fulfill_condition()


func complete_task(task: TaskCard) -> void:
	task_completed.emit(task)


func show_game_over_screen():
	$LetterUI.show_game_over()


func show_pause_screen():
	$PauseScreen.show_screen()


func hide_pause_screen():
	$PauseScreen.hide_screen()


func _on_pause_screen_unpause_game() -> void:
	enable_game.emit()


func _on_letter_ui_enable_game() -> void:
	enable_game.emit()


func _on_letter_ui_restart_game() -> void:
	restart_game.emit()
