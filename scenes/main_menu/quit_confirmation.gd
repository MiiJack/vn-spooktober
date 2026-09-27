extends CanvasLayer


func _on_yes_button_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_no_button_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
