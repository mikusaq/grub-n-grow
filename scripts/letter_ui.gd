extends Control

var state: int

func _ready() -> void:
	state = 0

func _on_button_pressed() -> void:
	if state == 0:
		var tween = create_tween()
		tween.tween_property($Letter1, "modulate:a", 0.0, Const.TRANSITION)
		await tween.finished
		$Letter1.queue_free()
		$Button.text = "Continue"
		state += 1
	elif state == 1:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, Const.TRANSITION)
		await tween.finished
		self.queue_free()
