# Handles unified aiming logic and exposes the computed target angle.
class_name PlayerAimController
extends Node2D

@export var stick_deadzone: float = 0.2
@export var default_direction: Vector2 = Vector2.RIGHT

var target_angle: float = 0.0
var _aim_direction: Vector2
var _last_mouse_screen_pos: Vector2 = Vector2.INF

func _ready() -> void:
	_aim_direction = _safe_normalized(default_direction)
	_last_mouse_screen_pos = _get_mouse_screen_position()
	_update_rotation()

func _process(_delta: float) -> void:
	var stick_vector := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if stick_vector.length() >= stick_deadzone:
		_aim_direction = stick_vector.normalized()
		_update_rotation()
		return

	var current_mouse_screen_pos := _get_mouse_screen_position()
	if current_mouse_screen_pos == _last_mouse_screen_pos:
		return

	_last_mouse_screen_pos = current_mouse_screen_pos
	var mouse_direction := get_global_mouse_position() - global_position
	if mouse_direction.is_zero_approx():
		return

	_aim_direction = mouse_direction.normalized()
	_update_rotation()

func get_aim_direction() -> Vector2:
	return _aim_direction

func _update_rotation() -> void:
	target_angle = _aim_direction.angle()
	rotation = target_angle

func _safe_normalized(vec: Vector2) -> Vector2:
	return Vector2.RIGHT if vec.is_zero_approx() else vec.normalized()

func _get_mouse_screen_position() -> Vector2:
	var viewport := get_viewport()
	return viewport.get_mouse_position() if viewport else Vector2.ZERO
