class_name option
extends CanvasLayer


@onready var music_volume_h_slider: HSlider = $VBoxContainer/MusicVolumeSlider/MusicVolumeHSlider
@onready var sfx_volume_h_slider: HSlider = $VBoxContainer/EffectVolumeSlider/SFXVolumeHSlider

var bus_music_idx := AudioServer.get_bus_index("BGM")
var bus_sfx_idx := AudioServer.get_bus_index("SFX")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#music volume setter
	music_volume_h_slider.set_value_no_signal(1)
	music_volume_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_music_idx))
	music_volume_h_slider.value_changed.connect(_on_music_value_changed)
	
	#sfx volume setter
	sfx_volume_h_slider.set_value_no_signal(1)
	sfx_volume_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx_idx))
	sfx_volume_h_slider.value_changed.connect(_on_sfx_value_changed)


func _on_music_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_music_idx, linear_to_db(new_value))

func _on_sfx_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(new_value))

func _on_return_pressed() -> void:
	queue_free()
