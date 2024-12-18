extends Control
@export var dialogue_items: Array[DialogueItem] = []
## UI element that shows the texts
@onready var rich_text_label: RichTextLabel = %RichTextLabel
## Audio player that plays voice sounds while text is being written
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
## The character
@onready var body: TextureRect = %Body
## The Expression
@onready var expression: TextureRect = %Expression
## The container for buttons
@onready var action_buttons_v_box_container: VBoxContainer = %ActionButtonsVBoxContainer


func _ready() -> void:
	show_text(0)


## Draws the selected text
## [param current_item_index] Displays the currently selected index from the dialogue array
func show_text(current_item_index: int) -> void:
	# We retrieve the current item from the array
	var current_item := dialogue_items[current_item_index]
	# We set the initial visible ratio to the text to 0, so we can change it in the tween
	rich_text_label.visible_ratio = 0.0
	# from the item, we extract the properties.
	# We set the text to the rich text control
	# And we set the appropriate expression texture
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
	create_buttons(current_item.choices)
	# We create a tween that will draw the text
	var tween := create_tween()
	# A variable that holds the amount of time for the text to show, in seconds
	# We could write this directly in the tween call, but this is clearer.
	# We will also use this for deciding on the sound length
	var text_appearing_duration := (current_item["text"] as String).length() / 30.0
	# We show the text slowly
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	# We randomize the audio playback's start time to make it sound different
	# every time.
	# We obtain the last possible offset in the sound that we can start from
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	# We pick a random position on that length
	var sound_start_position := randf() * sound_max_length
	# We start playing the sound
	audio_stream_player.play(sound_start_position)
	# We make sure the sound stops when the text finishes displaying
	tween.finished.connect(audio_stream_player.stop)
	
	# We animate the character sliding in.
	slide_in()
	# We disable all buttons until the tween completes
	for button: Button in action_buttons_v_box_container.get_children():
		button.disabled = true
	tween.finished.connect( func() -> void:
		for button: Button in action_buttons_v_box_container.get_children():
			button.disabled = false
	)


## Adds buttons to the buttons container
## [param buttons_data] An array of [DialogChoice]
func create_buttons(buttons_data: Array[DialogueChoice]) -> void:
	for button in action_buttons_v_box_container.get_children():
		button.queue_free()
	for choice in buttons_data:
		var button := Button.new()
		action_buttons_v_box_container.add_child(button)
		button.text = choice.text
		if choice.is_quit == true:
			button.pressed.connect(get_tree().quit)
		else:
			var target_line_id := choice.target_line_idx
			button.pressed.connect(show_text.bind(target_line_id))

## Animates the character when they start talking
func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
