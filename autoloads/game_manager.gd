extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_show_map_triggered)
	


func go_to(scene) -> void:
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	SceneTransition._fade_out()
	get_tree().change_scene_to_file(scene)
	SceneTransition._fade_in()
	

func _dialogic_ready() -> void:
	pass
	
func _on_show_map_triggered(argument: String) -> void:
	if argument == "show_map":
		print("map shown")
		go_to("res://scenes/level/world_map.tscn")
