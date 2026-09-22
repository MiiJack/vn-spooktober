extends CanvasLayer

##Note: for location and day progression naming
## day_01_main_road
## keep the naming consistent

var current_day: int = 0


func _go_to_location(location_id: String) -> void:
	current_day = Dialogic.VAR.get_variable("ChapterTracking.current_day")
	var timelime_name: String = "day_0%01d_%s" % [current_day, location_id]
	print(timelime_name)
	get_tree().current_scene.queue_free()
	Dialogic.start(timelime_name)

func _on_town_center_pressed() -> void:
	_go_to_location("town_center")


func _on_lake_side_pressed() -> void:
	_go_to_location("lake_side")


func _on_main_road_pressed() -> void:
	pass # Replace with function body.


func _on_cemetery_pressed() -> void:
	pass # Replace with function body.


func _on_forest_pressed() -> void:
	pass # Replace with function body.


func _on_hotel_pressed() -> void:
	pass # Replace with function body.
