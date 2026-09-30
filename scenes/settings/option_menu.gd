class_name option
extends CanvasLayer


@onready var music_volume_h_slider: HSlider = $VBoxContainer/MusicVolumeSlider/MusicVolumeHSlider
@onready var sfx_volume_h_slider: HSlider = $VBoxContainer/EffectVolumeSlider/SFXVolumeHSlider
@onready var text_speed_h_slider: HSlider = $VBoxContainer/TextSpeedSlider/TextSpeedHSlider
@onready var auto_skip_check_box: CheckBox = $VBoxContainer/HBoxAutoskip/AutoSkipCheckBox
@onready var text_advance_delay_h_slider: HSlider = $VBoxContainer/AutoAdvanceDelay/TextAdvanceDelayHSlider


var bus_music_idx := AudioServer.get_bus_index("BGM")
var bus_sfx_idx := AudioServer.get_bus_index("SFX")

signal set_autoskip_bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#music volume setter
	#music_volume_h_slider.set_value_no_signal(100)
	music_volume_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_music_idx))
	music_volume_h_slider.value_changed.connect(_on_music_value_changed)
	
	#sfx volume setter
	#sfx_volume_h_slider.set_value_no_signal(100)
	sfx_volume_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx_idx))
	sfx_volume_h_slider.value_changed.connect(_on_sfx_value_changed)
	
	##text speed setter
	#text_speed_h_slider.value_changed.connect(_on_text_speed_changed)
	#text_speed_h_slider.set_value_no_signal(GameManager.text_speed)
	
	#autoskip setter
	GameManager.option_screen_ready()
	auto_skip_check_box.button_pressed = GameManager.autoskip
	
	text_advance_delay_h_slider.value_changed.connect(_on_auto_advance_delay_changed)
	text_advance_delay_h_slider.set_value_no_signal(GameManager.auto_advance_speed)

func _on_music_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_music_idx, linear_to_db(new_value))

func _on_sfx_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(new_value))
	
#func _on_text_speed_changed(value: float) -> void:
	#value = text_speed_h_slider.value
	#if Dialogic:
		#GameManager.update_text_speed(value)


func _on_return_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_auto_skip_check_box_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	set_autoskip_bool.emit(toggled_on)
	

func _on_auto_advance_delay_changed(value: float) -> void:
	value = text_advance_delay_h_slider.value
	if Dialogic:
		GameManager.update_base_delay(value)
