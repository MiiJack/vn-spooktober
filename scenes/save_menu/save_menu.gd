extends CanvasLayer
## Save / load menu (res://scenes/save_menu/).
## Opened from the main menu in LOAD mode, and from inside the VN in SAVE mode.

enum Mode { SAVE, LOAD }

@export var mode: Mode = Mode.SAVE
@export var option_menu_ref : PackedScene

const SLOT_SCENE := preload("res://scenes/ui_components/save_slot_button.tscn")

@onready var _slot_list: VBoxContainer = %SlotList
@onready var _title_label: Label = %MenuTitle
@export var show_pause_menu_actions: bool = true

@export var quit_box_ref: PackedScene

@onready var _close_button: Button = $Control/VBoxContainer/CloseButton
@onready var _pause_only_nodes: Array[CanvasItem] = [
	$Control/VBoxContainer/MainMenu,
	$Control/VBoxContainer/Spacer2,
	$Control/VBoxContainer/Settings,
	$Control/VBoxContainer/Spacer3,
	$Control/VBoxContainer/QuitButton,
	$Control/VBoxContainer/Spacer,
]


func _ready() -> void:
	_title_label.text = "Save Game" if mode == Mode.SAVE else "Load Game"
	for node in _pause_only_nodes:
		node.visible = show_pause_menu_actions
	# "Continue" only makes sense when there's a paused game to continue.
	_close_button.text = "Continue" if show_pause_menu_actions else "Back"
	SaveManager.slots_changed.connect(_refresh)
	_refresh()

func close() -> void:
	queue_free()

func _refresh() -> void:
	for child in _slot_list.get_children():
		child.queue_free()

	# Quick-save slot first, and in SAVE mode it's read-only here
	# so it stays under the control of the quick-save key.
	if mode == Mode.LOAD:
		_add_slot(SaveManager.QUICK_SLOT, "Quick Save")

	for i in range(1, SaveManager.SLOT_COUNT + 1):
		_add_slot(SaveManager.get_slot_name(i), "Slot %d" % i)


func _add_slot(slot_name: String, display_name: String) -> void:
	var info : Dictionary = SaveManager.get_slot_display_info(slot_name)

	# Nothing to load from an empty slot, so don't offer it in LOAD mode.
	if mode == Mode.LOAD and not info.get("exists", false):
		return

	var slot := SLOT_SCENE.instantiate()
	_slot_list.add_child(slot)
	slot.setup(slot_name, display_name, info)
	slot.slot_pressed.connect(_on_slot_pressed)
	slot.slot_delete_requested.connect(_on_slot_delete_requested)


func _on_slot_pressed(slot_name: String) -> void:
	if mode == Mode.SAVE:
		SaveManager.save_to_slot(slot_name)
		# Overwriting is silent here. If we want an "overwrite?" prompt,
		# this is the single place to add it.
	else:
		SaveManager.load_slot(slot_name)
		close()


func _on_slot_delete_requested(slot_name: String) -> void:
	SaveManager.delete_slot(slot_name)


func _on_main_menu_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	if Dialogic.current_timeline:
		Dialogic.clear()
	GameManager.go_to("res://scenes/main_menu/main_menu.tscn")


func _on_settings_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	var new_option_menu = option_menu_ref.instantiate()
	add_child(new_option_menu)


func _on_close_button_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	Dialogic.paused = false
	queue_free()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("open_save_menu"):
		#queue_free()


func _on_quit_button_pressed() -> void:
	var new_quit_box = quit_box_ref.instantiate()
	add_child(new_quit_box)
