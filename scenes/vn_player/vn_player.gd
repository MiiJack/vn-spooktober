extends Node
## Host scene for the actual visual novel (res://scenes/vn_player/).
##
## This scene is deliberately almost empty. Dialogic builds its own dialogue
## layout and parents it to the scene tree root, 
## so this node's job is to own the session:

## Timeline played when starting a new game.
@export_file("*.dtl") var opening_timeline: String = "res://story/timelines/Prologue/Prologue.dtl"

## Save menu, instanced on demand rather than kept in the tree.
const SAVE_MENU_SCENE := preload("res://scenes/save_menu/save_menu.tscn")

var _save_menu: CanvasLayer = null

func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)

	# SaveManager parks a slot name here before changing scenes. Empty = new game.
	# Doing the load here (rather than in SaveManager) guarantees we are already
	# in the tree, so Dialogic never rebuilds its layout over the main menu.
	var slot := SaveManager.take_pending_slot()
	if slot.is_empty():
		Dialogic.start(opening_timeline)
	else:
		Dialogic.Save.load(slot)

func _unhandled_input(event: InputEvent) -> void:
	# These actions need to be added in Project Settings > Input Map.
	if event.is_action_pressed("quick_save"):
		SaveManager.quick_save()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("open_save_menu"):
		_open_save_menu()
		get_viewport().set_input_as_handled()


func _open_save_menu() -> void:
	if is_instance_valid(_save_menu):
		return

	# Grab the screenshot BEFORE the menu is on screen, otherwise every save
	# thumbnail is just a picture of the save menu.
	Dialogic.Save.take_thumbnail()

	_save_menu = SAVE_MENU_SCENE.instantiate()
	add_child(_save_menu)


func _on_timeline_ended() -> void:
	SaveManager.quit_to_menu()
