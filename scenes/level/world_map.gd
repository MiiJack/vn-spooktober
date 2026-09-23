extends CanvasLayer

##Note: for location and day progression naming
## day_01_main_road
## keep the naming consistent

@onready var location_buttons: Dictionary = {
	"town_center": $Buttons/TownCenter,
	"lake_side" : $Buttons/LakeSide,
	"main_road" : $Buttons/MainRoad,
	"cemetery" : $Buttons/Cemetery,
	"forest" : $Buttons/Forest,
	"hotel" : $Buttons/Hotel
}

var location_available_day: Dictionary = {
	1: ["town_center","main_road", "lake_side"],
	2: ["hotel", "cemetery", "lake_side"],
	3: ["main_road", "forest", "hotel"],
	4: ["cemetery", "main_road", "forest"],
	5: ["hotel", "town_center", "lake_side"],
	6: ["cemetery", "town_center", "forest"]
}

var current_day: int = 0

func _ready() -> void:
	_update_available_locations()
	
func _update_available_locations() -> void:
	current_day = Dialogic.VAR.get_variable("ChapterTracking.current_day")
	var open_locations: Array = location_available_day.get(current_day, [])
	for location_id in location_buttons.keys():
		var button: Button = location_buttons[location_id]
		button.visible = location_id in open_locations

func _go_to_location(location_id: String) -> void:
	current_day = Dialogic.VAR.get_variable("ChapterTracking.current_day")
	var timelime_name: String = "day_0%1d_%s" % [current_day, location_id]
	print(timelime_name)
	get_tree().current_scene.queue_free()
	Dialogic.start(timelime_name)

func _on_town_center_pressed() -> void:
	_go_to_location("town_center")

func _on_lake_side_pressed() -> void:
	_go_to_location("lake_side")

func _on_main_road_pressed() -> void:
	_go_to_location("main_road")

func _on_cemetery_pressed() -> void:
	_go_to_location("cemetery")

func _on_forest_pressed() -> void:
	_go_to_location("forest")

func _on_hotel_pressed() -> void:
	_go_to_location("hotel")
