extends Control

var state: int

signal enable_game
signal restart_game


func _ready() -> void:
	state = 0


func show_screen():
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, Const.TRANSITION)


func show_game_over():
	$Button.text = "Start again"
	$GameOverLetter.show()
	state = 3
	show_screen()


func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, Const.TRANSITION)
	await tween.finished


func _on_button_pressed() -> void:
	if state == 0:
		var tween = create_tween()
		tween.tween_property($Letter1, "modulate:a", 0.0, Const.TRANSITION)
		await tween.finished
		$Letter1.queue_free()
		$Button.text = "Continue"
		state += 1
	elif state == 1:
		fade_out()
		$Letter2.queue_free()
		hide()
		enable_game.emit()
		state += 1
	elif state == 2:
		fade_out()
		enable_game.emit()
		$Letter3.queue_free()
	elif state == 3:
		await fade_out()
		restart_game.emit()
