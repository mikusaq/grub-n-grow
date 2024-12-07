extends CanvasLayer


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credit_button_pressed() -> void:
	$CreditsScreen.show_screen()
