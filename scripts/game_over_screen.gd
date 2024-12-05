extends Control

signal start_new_game


func show_screen():
	modulate.a = 0.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, Const.TRANSITION)


func _on_button_pressed() -> void:
	start_new_game.emit()
