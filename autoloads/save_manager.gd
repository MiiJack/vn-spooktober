extends Node
## Save/load facade for the VN (autoload name: "SaveManager").
##
## Dialogic already saves and restores the entire story state: timeline position,
## variables, portraits, background, textbox contents and visited history.
## This exists only to add the things Dialogic deliberately leaves to the game:
##
##   1. A slot naming convention.
##   2. The "extra info" shown on each slot in the UI (date, chapter, last line).
##   3. Scene handling ; Dialogic restores the dialogue, not which scene you're in.
##
## Everything else is a straight pass-through to `Dialogic.Save`. If you need
## something here that Dialogic already does, use Dialogic's version.

const SLOT_COUNT := 6

## Dedicated slot for the quick-save key
const QUICK_SLOT := "quick"

const VN_PLAYER_SCENE := "res://scenes/vn_player/vn_player.tscn"
const MAIN_MENU_SCENE := "res://scenes/main_menu/main_menu.tscn"

## Emitted after a slot is written or deleted, so an open save menu can refresh.
signal slots_changed

## Cached from Dialogic so slots can show a "last line" preview.
var _last_line := ""
var _last_speaker := ""

## Set just before a scene change, consumed by vn_player once it is in the tree.
## Empty string means "start a new game".
var _pending_slot := ""

func _ready() -> void:
	# `Dialogic` does not exist yet during our _ready(). 
	# Waiting one frame is the simplest fix.
	await get_tree().process_frame
	Dialogic.Text.text_started.connect(_on_text_started)

#region SLOT NAMING
## Slots are `slot_1` ... `slot_N`.
func get_slot_name(index: int) -> String:
	return "slot_%d" % index

func get_all_slot_names() -> Array[String]:
	var names: Array[String] = []
	for i in range(1, SLOT_COUNT + 1):
		names.append(get_slot_name(i))
	return names
#endregion

#region SAVING
## Saves to `slot_name`, attaching the extra info the save menu displays.
##
## If you want a thumbnail attached, call `Dialogic.Save.take_thumbnail()`
## BEFORE opening the save menu (quick_save() already does this for you).
func save_to_slot(slot_name: String) -> bool:
	var extra_info := {
		"date": Time.get_datetime_string_from_system(false, true),
		"timeline": _get_current_timeline_name(),
		"speaker": _last_speaker,
		"text": _last_line,
	}

	# Explicit types here, not `:=`
	var thumbnail_mode: int = Dialogic.Save.ThumbnailMode.NONE
	if Dialogic.Save.latest_thumbnail != null:
		thumbnail_mode = Dialogic.Save.ThumbnailMode.STORE_ONLY

	var error: Error = Dialogic.Save.save(slot_name, false, thumbnail_mode, extra_info)

	if error != OK:
		push_error("[SaveManager] Failed to save slot '%s': %s" % [slot_name, error_string(error)])
		return false

	slots_changed.emit()
	return true

func quick_save() -> bool:
	Dialogic.Save.take_thumbnail()
	return save_to_slot(QUICK_SLOT)

func delete_slot(slot_name: String) -> void:
	if not Dialogic.Save.has_slot(slot_name):
		return
	Dialogic.Save.delete_slot(slot_name)
	slots_changed.emit()
#endregion

#region LOADING
## Returns the info a save menu needs to draw one slot.
## `exists` is false for an empty slot.
func get_slot_display_info(slot_name: String) -> Dictionary:
	if not Dialogic.Save.has_slot(slot_name):
		return {"exists": false}

	var info: Dictionary = Dialogic.Save.get_slot_info(slot_name)
	return {
		"exists": true,
		"date": info.get("date", ""),
		"timeline": info.get("timeline", ""),
		"speaker": info.get("speaker", ""),
		"text": info.get("text", ""),
		"thumbnail": Dialogic.Save.get_slot_thumbnail(slot_name),
	}

## Dialogic.start() on its own keeps variables, so without an explicit
##   FULL_CLEAR a "New Game" after a previous playthrough silently inherits the
##   old flags.
## Dialogic.clear() is a *coroutine* when a timeline is active (it awaits
##   the timeline's own cleanup). Not awaiting it means the clear is still in
##   flight while the new scene is already starting.
func start_new_game() -> void:
	await Dialogic.clear(Dialogic.ClearFlags.FULL_CLEAR)
	_pending_slot = ""
	GameManager.go_to(VN_PLAYER_SCENE)

## Loads a slot, from anywhere — main menu or mid-game.
##
## The order matters. `Dialogic.Save.load()` immediately rebuilds the dialogue
## layout and resumes the timeline, and that layout is parented to the scene tree
## root, NOT to the current scene. Calling it straight from the main menu leaves
## the menu sitting underneath a live conversation, still clickable.
##
## So we always route through the VN scene first and let it do the actual load
## once it is in the tree. Loading while already in the VN scene reloads it,
## which keeps a single code path for both cases.
func load_slot(slot_name: String) -> bool:
	if not Dialogic.Save.has_slot(slot_name):
		push_warning("[SaveManager] Tried to load empty slot '%s'." % slot_name)
		return false

	_pending_slot = slot_name
	SceneTransition.go_to(VN_PLAYER_SCENE)
	return true

func has_any_save() -> bool:
	return not Dialogic.Save.get_slot_names().is_empty()

## Loads the most recently saved/loaded slot. Use this for a "Continue" button.
func continue_latest() -> bool:
	var latest: String = Dialogic.Save.get_latest_slot()
	if latest.is_empty():
		return false
	return load_slot(latest)

## Called by vn_player once it is ready. Returns the slot to load,
## or "" to start the opening timeline instead.
func take_pending_slot() -> String:
	var slot := _pending_slot
	_pending_slot = ""
	return slot
#endregion

#region LEAVING THE STORY
## Ends the conversation and returns to the menu.
##
## `Dialogic.end_timeline()` is what actually removes the dialogue layout. Skipping
## it leaves the textbox floating on top of the main menu, because that layout node
## lives on the tree root and survives a scene change.
func quit_to_menu() -> void:
	await Dialogic.end_timeline()
	await Dialogic.clear(Dialogic.ClearFlags.FULL_CLEAR)
	SceneTransition.go_to(MAIN_MENU_SCENE)
#endregion

#region INTERNAL
func _on_text_started(info: Dictionary) -> void:
	_last_line = info.get("text", "")
	var character: DialogicCharacter = info.get("character")
	_last_speaker = character.get_display_name_translated() if character != null else ""

func _get_current_timeline_name() -> String:
	if Dialogic.current_timeline == null:
		return ""
	return Dialogic.current_timeline.resource_path.get_file().get_basename()
#endregion
