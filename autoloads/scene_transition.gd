extends Node
## Scene transition singleton (autoload name: "SceneTransition").
##
## Centralizes "go from screen A to screen B" so individual scenes
## (main menu, VN player, settings, credits) don't need to know about
## each other's file paths directly.

func go_to(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
