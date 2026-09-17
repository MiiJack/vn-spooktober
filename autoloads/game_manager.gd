extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to(scene) -> void:
	SceneTransition._fade_out()
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	SceneTransition._fade_in()
	get_tree().change_scene_to_file(scene)
