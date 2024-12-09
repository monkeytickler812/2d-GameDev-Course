extends Weapon

@export var base_damage := 2

var _charge_amount := 0.0

@onready var _cooldown_timer: Timer = %CooldownTimer


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		_charge_amount = min(1.0, _charge_amount + delta)
	elif Input.is_action_just_released("shoot") and _cooldown_timer.is_stopped():
		shoot()
		_cooldown_timer.start()
		_charge_amount = 0.0


func shoot() -> void:
	var bullet: Node = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.damage = floor(base_damage * (1.0 + _charge_amount))
	bullet.scale = Vector2.ONE * (1.0 + _charge_amount)
