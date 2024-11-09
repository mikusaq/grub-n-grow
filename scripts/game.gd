extends Node2D

@export var task_cards: Array[TaskCard]


func _ready() -> void:
	$HUD.set_money($Player.money)
	set_random_tasks()


func _process(delta: float) -> void:
	$World/FarmGrid.set_player_pos($Player.position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_day"):
		if $World/FarmGrid.in_season:
			$World/FarmGrid.process_end_of_season()
		else:
			$World/FarmGrid.process_next_season()


func set_random_tasks() -> void:
	var random_tasks: Array[TaskCard] = []
	var used_nums: Array[int] = []
	while random_tasks.size() < 3:
		var rand_num = randi_range(0, task_cards.size() - 1)
		if rand_num not in used_nums:
			random_tasks.append(task_cards[rand_num])
			used_nums.append(rand_num)
	
	$HUD.set_task_cards(random_tasks)


func _on_hud_add_money(money: int) -> void:
	$Player.money += money
	$HUD.set_money($Player.money)
