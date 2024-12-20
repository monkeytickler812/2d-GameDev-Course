extends CharacterBody2D

## The top speed that the runner can achieve
@export var max_speed := 600.0
## How much speed is added per second when the player presses a movement key
@export var acceleration := 1200.0
## How much speed is lost per second when the player releases all movement keys
@export var deceleration := 1080.0

@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(get_global_mouse_position())
	var distance := global_position.distance_to(get_global_mouse_position())
	var speed := max_speed if distance > 100 else max_speed * distance / 100

	var desired_velocity := direction * speed

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	if velocity.length() > 10.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)

		var current_speed_percent := velocity.length() / max_speed
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)

		_dust.emitting = true
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
