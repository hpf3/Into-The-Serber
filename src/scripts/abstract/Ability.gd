@abstract
class_name Ability
extends Node

@export var priority: int = 0  # used only for deterministic triggering order
@export var cooldown_seconds := 0.5
var _cooldown_left := 0.0

func _physics_process(delta: float) -> void:
    if _cooldown_left > 0.0:
        _cooldown_left -= delta

func get_cooldown() -> float: return cooldown_seconds
func get_cooldown_left() -> float: return max(_cooldown_left, 0.0)
func get_cooldown_percent() -> float:
    var cd := get_cooldown()
    return 0.0 if cd <= 0.0 else clamp(1.0 - (get_cooldown_left() / cd), 0.0, 1.0)

func can_trigger(_state: PlayerContext) -> bool:
    return get_cooldown_left() <= 0.0

@abstract
func trigger(state: PlayerContext) -> void

func start_cooldown(): _cooldown_left = get_cooldown()

func collect_stat_modifiers(_bus: Node, _state: PlayerContext) -> void:
    pass
