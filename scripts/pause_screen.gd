extends Control



func show_screen():
	modulate.a = 0.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, Const.TRANSITION)


func _on_how_to_play_button_pressed() -> void:
	$HowToPlayScreen.show()


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")


func _on_back_button_pressed() -> void:
	$HowToPlayScreen.hide()
