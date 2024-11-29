extends Node2D

@export var task_cards: Array[TaskCard]
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
		if turn_number > 1 and completed_tasks_in_turn == 0:
			Engine.time_scale = 0
			$HUD.show_game_over_screen()
		completed_tasks_in_turn = 0


func set_random_tasks() -> void:
	var random_tasks: Array[TaskCard] = []
	var used_nums: Array[int] = []
	while random_tasks.size() < 3:
		var rand_num = randi_range(0, task_cards.size() - 1)
		if rand_num not in used_nums:
			random_tasks.append(task_cards[rand_num])
			used_nums.append(rand_num)
	
	$HUD.add_task_cards(random_tasks)


func _on_hud_task_completed(reward: int) -> void:
	$Player.money += reward
	$HUD.set_money($Player.money)
	var rand_num = randi_range(0, task_cards.size() - 1)
	var task_array: Array[TaskCard] = [task_cards[rand_num]]
	completed_tasks_in_turn += 1
	$HUD.add_task_cards(task_array)


func _on_hud_restart_game() -> void:
	Engine.time_scale = 1
	var tree := get_tree()
	var scene_path := tree.current_scene.scene_file_path
	tree.call_deferred("unload_current_scene")
	tree.call_deferred("change_scene_to_file", scene_path)
