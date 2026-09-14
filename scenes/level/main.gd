extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("intro_prologue", 0)
