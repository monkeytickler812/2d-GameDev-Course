## Base class for enemies. Defines some functions you can reuse to create
## different kinds of enemies.
#ANCHOR:l07_01
class_name Mob extends CharacterBody2D

@export var max_speed := 250.0
@export var acceleration := 700.0
#END:l07_01
#ANCHOR:l09_01
@export var health := 3: set = set_health
#END:l09_01
@export var damage := 1


#ANCHOR:l07_02
var _player: Player = null

@onready var _detection_area: Area2D = %DetectionArea
#END:l07_02
#ANCHOR:l09_03
@onready var _die_sound: AudioStreamPlayer2D = %DieSound
#END:l09_03
@onready var _hit_box: Area2D = %HitBox


#ANCHOR:ready_definition
func _ready() -> void:
	#END:ready_definition
	#ANCHOR:l07_03
	_detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	_detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)
	#END:l07_03

	_hit_box.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.health -= damage
	)


#ANCHOR:l09_04
func set_health(new_health: int) -> void:
	health = new_health
	if health <= 0:
		die()


func die() -> void:
	if _hit_box == null:
		return
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	_die_sound.play()
	_die_sound.finished.connect(queue_free)
	#END:l09_04
	_hit_box.queue_free()


#ANCHOR:l07_04
func _physics_process(delta: float) -> void:
	if _player == null:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		var direction := global_position.direction_to(_player.global_position)
		var distance := global_position.distance_to(_player.global_position)
		var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)

	move_and_slide()
	#END:l07_04
