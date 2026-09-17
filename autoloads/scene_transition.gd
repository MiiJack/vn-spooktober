extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _fade_out(duration: float = 1.0) -> void:
	visible = true
	color_rect.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished
	
	
func _fade_in(duration: float = 1.0) -> void:
	color_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	visible = false
