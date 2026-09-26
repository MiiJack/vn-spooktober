extends Node

var catherine_sympathy: int = 0
var marloch_feeling: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_ending_triggered)

func _on_ending_triggered(argument: String) -> void:
	if argument == "trigger_ending":
		print("endign_triggerd")
		
		catherine_sympathy = Dialogic.VAR.get_variable("EndingTracking.catherine_sympathy")
		marloch_feeling = Dialogic.VAR.get_variable("EndingTracking.marloch_feeling")
		#ending 1
		if catherine_sympathy > 0 and marloch_feeling > 0:
			Dialogic.start_timeline("ending_01")
		elif catherine_sympathy <= 0 and marloch_feeling > 0:
		#ending 2
			Dialogic.start_timeline("ending_02")
		#ending 3
		elif catherine_sympathy > 0 and marloch_feeling <= 0:
			Dialogic.start_timeline("ending_03")
		#ending 4
		elif catherine_sympathy <= 0 and marloch_feeling <= 0:
			Dialogic.start_timeline("ending_04")
