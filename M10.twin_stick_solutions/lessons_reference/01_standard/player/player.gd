class_name Player
extends CharacterBody2D

#ANCHOR:l4_01
@export var speed := 460.0
@export var drag_factor := 10.0
#END:l4_01
#ANCHOR:l10_01
@export var max_health := 5

var health := max_health: set = set_health

@onready var _damage_audio: AudioStreamPlayer2D = %DamageAudio
@onready var _die_audio: AudioStreamPlayer2D = %DieAudio
@onready var _health_bar: ProgressBar = %HealthBar
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	_health_bar.max_value = max_health
	_health_bar.value = health
	#END:l10_01


#ANCHOR:l4_02
func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * drag_factor * delta
	move_and_slide()
#END:l4_02


#ANCHOR:l10_02
func set_health(new_health: int) -> void:
	var previous_health := health
	health = clampi(new_health, 0, max_health)
	_health_bar.value = health

	if health == 0:
		die()
	elif previous_health > health:
		_damage_audio.play()


func die() -> void:
	_die_audio.play()
	set_physics_process(false)
	_collision_shape_2d.set_deferred("disabled", true)
	_die_audio.finished.connect(
		get_tree().reload_current_scene
	)
	#END:l10_02
