extends Button
## One row in the save menu (res://scenes/ui_components/).
##
## Deliberately dumb: it renders whatever slot info it's handed and reports
## what the player did. It does not save, load, or delete anything itself —
## the save menu owns that decision. Keeps this widget reusable for a future
## "Continue" screen or chapter-select without dragging save logic along.

signal slot_pressed(slot_name: String)
signal slot_delete_requested(slot_name: String)

@onready var _thumbnail: TextureRect = %Thumbnail
@onready var _title_label: Label = %TitleLabel
@onready var _date_label: Label = %DateLabel
@onready var _preview_label: Label = %PreviewLabel
@onready var _delete_button: Button = %DeleteButton

var _slot_name := ""


func _ready() -> void:
	pressed.connect(func() -> void: slot_pressed.emit(_slot_name))
	_delete_button.pressed.connect(func() -> void: slot_delete_requested.emit(_slot_name))


## `display_name` is what the player sees ("Slot 1"); `slot_name` is the
## on-disk folder ("slot_1"). Keeping them separate means the visible label can
## be renamed or translated without breaking existing save files.
func setup(slot_name: String, display_name: String, info: Dictionary) -> void:
	_slot_name = slot_name
	_title_label.text = display_name

	var exists: bool = info.get("exists", false)
	_delete_button.visible = exists

	if not exists:
		_date_label.text = ""
		_preview_label.text = "— Empty —"
		_thumbnail.texture = null
		return

	_date_label.text = info.get("date", "")
	_thumbnail.texture = info.get("thumbnail")

	var speaker: String = info.get("speaker", "")
	var text: String = info.get("text", "")
	_preview_label.text = ("%s: %s" % [speaker, text]) if not speaker.is_empty() else text
