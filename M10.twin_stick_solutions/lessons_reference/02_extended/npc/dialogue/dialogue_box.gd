class_name DialogueBox extends Control

signal dialogue_finished

@export var dialogue: Dialogue = null
var current_item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression_texture_rect: TextureRect = %Expression


func _ready() -> void:
	next_button.pressed.connect(advance)


func play_dialogue() -> void:
	assert(
		dialogue != null,
		"The dialogue box has no dialogue resource but needs one to play a dialogue."
	)
	current_item_index = 0
	show_text()
	slide_character_in()


func show_text() -> void:
	var current_item := dialogue.entries[current_item_index]
	rich_text_label.text = current_item.text
	expression_texture_rect.texture = current_item.expression
	body.texture = current_item.character
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration := (current_item["text"] as String).length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)


func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue.entries.size():
		hide()
		dialogue_finished.emit()
	else:
		show_text()


func slide_character_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
