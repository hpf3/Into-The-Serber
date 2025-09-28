@abstract
class_name NpcCapability
extends Node

var bus: SignalBus
var host: Node

func _ready() -> void:
    bus = _find_signal_bus(self)
    host = bus.get_parent() if bus else null
    assert(bus, "SignalBus not found on NPC")

    _on_attached()

func _exit_tree() -> void:
    _on_detached()

@abstract
func _on_attached() -> void
@abstract
func _on_detached() -> void

@abstract
func get_npc_data(key: int) -> Variant

# Helper to connect safely if a handler exists
func _connect_if(sig: StringName, method: StringName) -> void:
    if has_method(method):
        bus.connect(sig, Callable(self, method))
    else:
        push_warning("Method '%s' not found in %s, cannot connect to signal '%s'." % [method, self, sig])



func _find_signal_bus(start: Node) -> SignalBus:
    var current := start
    while current:
        var parent := current.get_parent()
        if parent == null:
            return null
        for sibling in parent.get_children():
            if sibling == current:
                continue
            if sibling is SignalBus:
                return sibling
        if parent is CharacterBody2D:
            return null
        current = parent
    return null
