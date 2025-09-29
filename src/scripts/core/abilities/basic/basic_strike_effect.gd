class_name BasicStrikeEffect
extends Node2D

@export var animation: AnimatedSprite2D
@export var damage_area: Area2D
@export var fallback_lifetime: float = 0.25

var _damage_amount: float = 0.0
var _knockback_force: float = 0.0
var _animation_speed: float = 1.0
var _source: Node
var _direction := Vector2.RIGHT

func _ready() -> void:
    _assertions()
    _prepare_animation()
    if damage_area != null:
        damage_area.set_deferred("monitoring", true)
        damage_area.body_entered.connect(_apply_damage)
    else:
        push_warning("BasicStrikeEffect has no damage_area assigned; it will not deal damage.")


func configure(source: Node, direction: Vector2, damage_amount: float, knockback_force: float, animation_speed: float = 1.0) -> void:
    _source = source
    _direction = Vector2.RIGHT if direction.is_zero_approx() else direction.normalized()
    _damage_amount = damage_amount
    _knockback_force = knockback_force
    _animation_speed = max(animation_speed, 0.01)
    rotation = _direction.angle()
    _play_animation()


func _assertions() -> void:
    assert(damage_area != null, "BasicStrikeEffect requires an Area2D assigned to 'damage_area'.")


func _prepare_animation() -> void:
    if animation == null:
        _start_fallback_timer()
        return

    animation.stop()
    animation.visible = false
    animation.frame = 0
    if not animation.animation_finished.is_connected(_on_animation_finished):
        animation.animation_finished.connect(_on_animation_finished)


func _play_animation() -> void:
    if animation == null:
        return
    animation.visible = true
    animation.speed_scale = _animation_speed
    animation.set_frame_and_progress(0, 0.0)
    animation.play()


func _apply_hit(body: Node) -> void:
    if body == null:
        return

    var bus := body.get_node_or_null("SignalBus")
    if bus is SignalBus:
        bus.emit_hit(_damage_amount, self)
        if _knockback_force != 0.0:
            bus.emit_knockback(_knockback_force, _direction)
        return

    if _knockback_force != 0.0:
        var knock_vector := _direction * _knockback_force
        body.set_meta("knockback", knock_vector)


func _apply_damage(_body: Node) -> void:
    if damage_area == null:
        return

    var bodies := damage_area.get_overlapping_bodies()
    for body in bodies:
        _apply_hit(body)

    _teardown_damage_signal()


func _teardown_damage_signal() -> void:
    if damage_area == null:
        return

    if damage_area.body_entered.is_connected(_apply_damage):
        damage_area.body_entered.disconnect(_apply_damage)
    damage_area.set_deferred("monitoring", false)


func _on_animation_finished() -> void:
    queue_free()


func _start_fallback_timer() -> void:
    if fallback_lifetime <= 0.0:
        queue_free()
        return
    var timer := Timer.new()
    timer.one_shot = true
    timer.wait_time = fallback_lifetime
    add_child(timer)
    timer.timeout.connect(queue_free)
    timer.start()
