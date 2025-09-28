extends NpcCapability

@export
var max_health: float = 100.0
var current_health: float

func _on_attached() -> void:
    current_health = max_health
    _connect_if("hit", "_on_hit")
    bus.register_provider(self)


func _on_detached() -> void:
    bus.unregister_provider(self)


func get_npc_data(key: int) -> Variant:
    match key:
        NpcContracts.DataKey.HP_CUR:
            return current_health
        NpcContracts.DataKey.HP_MAX:
            return max_health
    return null

func _on_hit(amount: float, source: Node) -> void:
    current_health -= amount
    if current_health < 0:
        current_health = 0
    bus.emit_damaged(amount, current_health, max_health, source)
    if current_health <= 0:
        bus.emit_died()
