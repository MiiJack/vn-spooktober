extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGM.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.1).timeout
	GameManager.go_to("res://scenes/main_menu/main_menu.tscn")
