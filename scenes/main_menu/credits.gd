extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
