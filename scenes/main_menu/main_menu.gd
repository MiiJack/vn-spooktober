extends CanvasLayer

@export var option_menu_ref: PackedScene
@export var quit_box_ref: PackedScene
@export var credit_menu_ref: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_button_pressed() -> void:
	GameManager.go_to("res://scenes/level/main.tscn")


func _on_option_button_pressed() -> void:
	var new_option_menu = option_menu_ref.instantiate()
	add_child(new_option_menu)


func _on_quit_button_pressed() -> void:
	var new_quit_box = quit_box_ref.instantiate()
	add_child(new_quit_box)


func _on_credits_button_pressed() -> void:
	var new_credit_menu = credit_menu_ref.instantiate()
	add_child(new_credit_menu)
