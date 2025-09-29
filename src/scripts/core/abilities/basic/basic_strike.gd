extends Ability

@export var effect_scene: PackedScene = preload("res://scenes/core/abilities/basic/basic_strike.tscn")
@export var damage: float = 1.0
@export var knockback: float = 200.0
@export var distance: float = 20.0
@export var attack_speed_multiplier: float = 1.0
@export var effect_parent_path: NodePath

const MIN_ATTACK_SPEED := 0.01
const DEFAULT_DIRECTION := Vector2.RIGHT

func _ready() -> void:
    _assertions()


func _assertions() -> void:
    assert(effect_scene != null, "BasicStrike ability requires an effect scene assigned to 'effect_scene'.")


func trigger(state: PlayerContext) -> void:
    if not can_trigger(state):
        return

    var attack_speed_mod: float = max(state.stats.attack_speed * max(attack_speed_multiplier, 0.0), MIN_ATTACK_SPEED)
    var direction := _resolve_direction(state)

    _spawn_effect(state, direction, attack_speed_mod)
    _apply_cooldown(attack_speed_mod)


func _resolve_direction(state: PlayerContext) -> Vector2:
    if not state.aim_direction.is_zero_approx():
        return state.aim_direction.normalized()
    if not state.velocity.is_zero_approx():
        return state.velocity.normalized()
    return DEFAULT_DIRECTION


func _spawn_effect(state: PlayerContext, direction: Vector2, attack_speed_mod: float) -> void:
    if effect_scene == null:
        return

    var instance := effect_scene.instantiate()
    if instance == null:
        return

    var parent := _resolve_effect_parent(state)
    if parent == null:
        instance.queue_free()
        return

    parent.add_child(instance)

    var effect_node2d := instance as Node2D
    if effect_node2d != null:
        if parent is Node2D:
            effect_node2d.position = direction * distance
        else:
            effect_node2d.global_position = state.player.global_position + direction * distance
    else:
        push_warning("BasicStrike effect scene should inherit Node2D for positioning.")

    var damage_amount := _compute_damage(state)
    if instance is BasicStrikeEffect:
        (instance as BasicStrikeEffect).configure(state.player, direction, damage_amount, knockback, attack_speed_mod)
    elif instance.has_method("configure"):
        instance.configure(state.player, direction, damage_amount, knockback, attack_speed_mod)


func _resolve_effect_parent(state: PlayerContext) -> Node:
    if effect_parent_path != NodePath():
        var anchor := state.player.get_node_or_null(effect_parent_path)
        if anchor != null:
            return anchor
    return state.player


func _apply_cooldown(attack_speed_mod: float) -> void:
    start_cooldown()
    if attack_speed_mod > MIN_ATTACK_SPEED:
        _cooldown_left /= attack_speed_mod


func _compute_damage(state: PlayerContext) -> float:
    var dmg_multiplier :float= max(damage, 0.0)
    return max(state.stats.damage * dmg_multiplier, 0.0)
