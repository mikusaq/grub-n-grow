extends Node2D

@export var task_cards: Array[TaskCard]
var used_tasks: Array[TaskCard] = []
var turn_number: int = 0
var completed_tasks_in_turn: int = 0
var game_enabled: bool:
	set(new_value):
		game_enabled = new_value
		$Player.game_enabled = new_value
		$World.game_enabled = new_value


func _ready() -> void:
	$HUD.set_money($Player.money)
	set_random_tasks()
	game_enabled = false


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if game_enabled:
			var mouse_pos = get_global_mouse_position()
			$World/FarmGrid.process_click(mouse_pos)
	elif event.is_action_pressed("pause"):
		if game_enabled:
			pause_game()
		elif not $HUD/LetterUI:
			unpause_game()


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


func _fade_out_and_update_farm():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 0.8)
	await tween.finished
	$World/FarmGrid.process_next_turn()
	await get_tree().create_timer(0.4).timeout
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.8)
	await tween.finished


func pause_game():
	game_enabled = false
	$HUD.show_pause_screen()


func unpause_game():
	$HUD.hide_pause_screen()
	game_enabled = true


func _on_hud_task_completed(completed_task: TaskCard) -> void:
	$CompletedTaskSound.play()
	$Player.money += completed_task.reward
	$HUD.set_money($Player.money)
	used_tasks.erase(completed_task)
	var task_card: TaskCard = get_not_present_task()
	used_tasks.append(task_card)
	var task_array: Array[TaskCard] = [task_card]
	completed_tasks_in_turn += 1
	$HUD.add_task_cards(task_array)


func _on_hud_restart_game() -> void:
	var tree := get_tree()
	var scene_path := tree.current_scene.scene_file_path
	tree.call_deferred("unload_current_scene")
	tree.call_deferred("change_scene_to_file", scene_path)


func _on_world_next_turn() -> void:
	game_enabled = false
	turn_number += 1
	if completed_tasks_in_turn == 0 and turn_number > 1:
		$HUD.show_game_over_screen()
	else:
		await _fade_out_and_update_farm()
		game_enabled = true
	completed_tasks_in_turn = 0


func _on_world_work_on_farm_grid() -> void:
	$Player.play_work_animation()


func _on_hud_enable_game() -> void:
	game_enabled = true
