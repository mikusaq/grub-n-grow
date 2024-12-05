extends Control

const TRANSITION = 0.15

signal hide_credits


func show_screen():
	modulate.a = 0.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, TRANSITION)


func _on_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, TRANSITION)
	await tween.finished
	hide()
