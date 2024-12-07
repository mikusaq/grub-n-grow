extends Label

var tween: Tween

func _ready() -> void:
	modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

func _on_timer_timeout() -> void:
	queue_free()
