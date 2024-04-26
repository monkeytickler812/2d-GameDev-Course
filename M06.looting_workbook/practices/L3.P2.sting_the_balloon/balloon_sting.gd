extends Area2D


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	queue_free()


func _on_mouse_entered() -> void:
	pass
