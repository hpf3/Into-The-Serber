extends NpcCapability

@export
var log_name: String = "NPC"

func _on_attached() -> void:
    _connect_if("damaged", "_on_damaged")
func _on_detached() -> void:
    pass
func get_npc_data(_key: int) -> Variant:
    return null

func _on_damaged(amount: float, hp_cur: float, hp_max: float, source: Node) -> void:
    print(log_name, " took ", amount, " damage from ", source, ". HP: ", hp_cur, "/", hp_max)

