class_name PlayerMovement
extends Resource

@export var acceleration: float = 1200.0
@export var deceleration: float = 1600.0

func apply(player: CharacterBody2D, stats: Stats, delta: float) -> Vector2:
	var input_vec := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_vec.length_squared() > 1.0:
		input_vec = input_vec.normalized()

	var target_velocity := input_vec * stats.move_speed
	var velocity := player.velocity

	if input_vec.is_zero_approx():
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)

	player.velocity = velocity
	return velocity
