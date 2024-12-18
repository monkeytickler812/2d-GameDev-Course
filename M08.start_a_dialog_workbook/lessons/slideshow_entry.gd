class_name SlideShowEntry extends Resource
@export_group("Images")
## Represents the character's expression for this dialogue bubble
@export var expression := preload("res://assets/emotion_regular.png")
## Represents the character's body for this dialogue bubble
@export var character := preload("res://assets/sophia.png")

@export_group("Text")
## The text of this dialogue bubble
@export_multiline var text := ""
