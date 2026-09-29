extends Node

var vn_player_ref: vn_player

@onready var map_ref: PackedScene = preload("res://scenes/level/world_map.tscn")

var autoskip: bool

var option_menu_ref: option

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_show_map_triggered)
	option_menu_ref = get_tree().get_first_node_in_group("options_group")
	print(option_menu_ref)
	if option_menu_ref:
		option_menu_ref.set_autoskip_bool.connect(_on_autoskip_set)


func go_to(scene_path:String) -> void:
	await SceneTransition._fade_out()
	
	var scene := get_tree().change_scene_to_file(scene_path)
	if scene != OK:
		push_error("[SceneTransition] Could not change to '%s': %s" % [scene_path, error_string(scene)])
		
	await get_tree().process_frame
	SceneTransition._fade_in()
	
	
func _on_show_map_triggered(argument: String) -> void:
	if argument == "show_map":
		print("map shown")
		var new_map = map_ref.instantiate()
		await SceneTransition._fade_out()
		get_tree().root.add_child(new_map)
		SceneTransition._fade_in()

func _on_autoskip_set(toggled_on: bool) -> void:
	autoskip = toggled_on
	if Dialogic:
		Dialogic.Inputs.auto_skip.enabled = autoskip

	
