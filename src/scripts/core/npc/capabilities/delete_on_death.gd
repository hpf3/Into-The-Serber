extends NpcCapability

func _on_attached() -> void:
    _connect_if("died", "_on_died")
func _on_detached() -> void:
    pass
func get_npc_data(_key: int) -> Variant:
    return null
func _on_died() -> void:
    host.queue_free()
