extends Node2D

@export var task_cards: Array[TaskCard]
var used_tasks: Array[TaskCard] = []
var turn_number: int = 0
var completed_tasks_in_turn: int = 0


func _ready() -> void:
	$HUD.set_money($Player.money)
	set_random_tasks()


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		turn_number += 1
		$World/FarmGrid.process_next_turn()
		if completed_tasks_in_turn == 0 and turn_number > 1:
			Engine.time_scale = 0
			$HUD.show_game_over_screen()
		completed_tasks_in_turn = 0


func get_not_present_task() -> TaskCard:
	var task_card: TaskCard = null
	while not task_card:
		var rand_num = randi_range(0, task_cards.size() - 1)
		if task_cards[rand_num] not in used_tasks:
			task_card = task_cards[rand_num]
	return task_card


func set_random_tasks() -> void:
	while used_tasks.size() < 3:
		used_tasks.append(get_not_present_task())
	
	$HUD.add_task_cards(used_tasks)


func _on_hud_task_completed(completed_task: TaskCard) -> void:
	$Player.money += completed_task.reward
	$HUD.set_money($Player.money)
	used_tasks.erase(completed_task)
	var task_card: TaskCard = get_not_present_task()
	used_tasks.append(task_card)
	var task_array: Array[TaskCard] = [task_card]
	completed_tasks_in_turn += 1
	$HUD.add_task_cards(task_array)


func _on_hud_restart_game() -> void:
	Engine.time_scale = 1
	var tree := get_tree()
	var scene_path := tree.current_scene.scene_file_path
	tree.call_deferred("unload_current_scene")
	tree.call_deferred("change_scene_to_file", scene_path)
