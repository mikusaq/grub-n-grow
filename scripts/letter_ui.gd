extends Control

var state: int

func _ready() -> void:
	state = 0

func _on_button_pressed() -> void:
	if state == 0:
		$Letter1.queue_free()
		$Button.text = "Quit"
		state += 1
	elif state == 1:
		self.queue_free()
