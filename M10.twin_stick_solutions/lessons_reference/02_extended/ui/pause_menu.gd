extends Control

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

var _tween: Tween

@onready var _resume_button: Button = %ResumeButton
@onready var _quit_button: Button = %QuitButton

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	menu_opened_amount = 0.0

	_resume_button.pressed.connect(toggle.bind(false))
	_quit_button.pressed.connect(get_tree().quit)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if menu_opened_amount < 0.5:
			toggle(true)
		else:
			toggle(false)


func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0

	if _panel_container == null or _color_rect == null:
		return

	_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
	_panel_container.modulate.a = amount
	get_tree().paused = amount > 0.3


func toggle(is_toggled: bool) -> void:
	var duration := 0.5
	if _tween != null:
		duration = _tween.get_total_elapsed_time()
		_tween.kill()

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	var target_amount := 1.0 if is_toggled else 0.0
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
