extends Node
class_name SignalBus

# ---- Typed signals
signal init()
func emit_init() -> void: emit_signal("init")

signal tick(delta: float)
func emit_tick(delta: float) -> void: emit_signal("tick", delta)

signal hit(amount: float, source: Node)
func emit_hit(amount: float, source: Node) -> void: emit_signal("hit", amount, source)

signal damaged(amount: float, hp_cur: float, hp_max: float, source: Node)
func emit_damaged(amount: float, hp_cur: float, hp_max: float, source: Node) -> void:
    emit_signal("damaged", amount, hp_cur, hp_max, source)

signal died()
func emit_died() -> void: emit_signal("died")

# ---- Provider registry (for typed queries)
var _providers: Array[Node] = []

func register_provider(p: Node) -> void:
    if not _providers.has(p):
        _providers.append(p)

func unregister_provider(p: Node) -> void:
    _providers.erase(p)

# Typed query: use enum keys; return null if no provider serves it.
func query(key: int, default_value :Variant= null):
    for p in _providers:
        if p.has_method("get_npc_data"):
            var v = p.get_npc_data(key)
            if v != null:
                return v
    return default_value
