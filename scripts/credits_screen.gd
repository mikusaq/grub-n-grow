extends Control

signal hide_credits


func show_screen():
	modulate.a = 0.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, Const.TRANSITION)


func _on_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, Const.TRANSITION)
	await tween.finished
	hide()
