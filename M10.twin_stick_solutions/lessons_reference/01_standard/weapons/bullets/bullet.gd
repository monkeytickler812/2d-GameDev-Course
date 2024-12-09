#ANCHOR:l05_01
class_name Bullet extends Area2D

@export var speed := 750
#END:l05_01
@export var damage := 1

#ANCHOR:l05_02
var max_range := 1000.0

var _traveled_distance = 0.0
#END:l05_02


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		if body is Mob:
			body.health -= damage
		_destroy()
	)


#ANCHOR:l05_03
func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := Vector2.RIGHT.rotated(rotation) * distance

	position += motion

	_traveled_distance += distance
	if _traveled_distance > max_range:
		_destroy()
		#END:l05_03


#ANCHOR:l05_04
func _destroy():
	queue_free()
	#END:l05_04
