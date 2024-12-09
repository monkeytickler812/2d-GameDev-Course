extends Bullet


func _physics_process(delta: float) -> void:
	super(delta)
	scale += Vector2.ONE * 2.0 * delta
