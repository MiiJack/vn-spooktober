class_name option
extends CanvasLayer


@onready var music_volume_h_slider: HSlider = $VBoxContainer/MusicVolumeSlider/MusicVolumeHSlider
@onready var sfx_volume_h_slider: HSlider = $VBoxContainer/EffectVolumeSlider/SFXVolumeHSlider
@onready var text_speed_h_slider: HSlider = $VBoxContainer/TextSpeedSlider/TextSpeedHSlider
@onready var auto_skip_check_box: CheckBox = $VBoxContainer/HBoxAutoskip/AutoSkipCheckBox


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
	
	#text speed setter
	text_speed_h_slider.value_changed.connect(_on_text_speed_changed)
	
	#autoskip setter
	auto_skip_check_box.toggle_mode = GameManager.autoskip

func _on_music_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_music_idx, linear_to_db(new_value))

func _on_sfx_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(new_value))
	
func _on_text_speed_changed(value: float) -> void:
	if Dialogic:
		Dialogic.Settings.text_speed = text_speed_h_slider.max_value - value


func _on_return_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_auto_skip_check_box_toggled(toggled_on: bool) -> void:
	set_autoskip_bool.emit(toggled_on)
