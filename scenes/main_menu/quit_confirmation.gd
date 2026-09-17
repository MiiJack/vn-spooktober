extends CanvasLayer


func _on_yes_button_pressed() -> void:
	get_tree().quit()


func _on_no_button_pressed() -> void:
	queue_free()
