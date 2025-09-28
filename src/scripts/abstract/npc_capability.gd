@abstract
class_name NpcCapability
extends Node

var bus: SignalBus
var host: Node

func _ready() -> void:
    host = get_owner()
    bus = host.get_node_or_null("SignalBus")
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
