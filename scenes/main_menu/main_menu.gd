extends CanvasLayer

@export var option_menu_ref: PackedScene
@export var quit_box_ref: PackedScene
@export var credit_menu_ref: PackedScene

@onready var _continue_button: Button = %ContinueButton
@onready var _load_button: Button = %LoadButton

const SAVE_MENU_SCENE := preload("res://scenes/save_menu/save_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var has_saves := SaveManager.has_any_save()
	_continue_button.disabled = not has_saves
	_load_button.disabled = not has_saves

func _open_load_menu() -> void:
	var menu := SAVE_MENU_SCENE.instantiate()
	menu.mode = menu.Mode.LOAD
	add_child(menu)
	
func _start_game() -> void:
	SaveManager.start_new_game()
	
func _continue_game() -> void:
	SaveManager.continue_latest()
	
func _load_game() -> void:
	_open_load_menu()


func _on_option_button_pressed() -> void:
	var new_option_menu = option_menu_ref.instantiate()
	add_child(new_option_menu)


func _on_quit_button_pressed() -> void:
	var new_quit_box = quit_box_ref.instantiate()
	add_child(new_quit_box)


func _on_credits_button_pressed() -> void:
	var new_credit_menu = credit_menu_ref.instantiate()
	add_child(new_credit_menu)
