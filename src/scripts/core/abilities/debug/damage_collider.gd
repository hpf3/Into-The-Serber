extends Area2D
class_name DamageCollider

@export
var damage_amount: float = 10.0
var lifetime_seconds: float = 0.1
var _lifetime_left: float = lifetime_seconds

func _ready() -> void:
    self.collision_mask = 4
    var shape = CircleShape2D.new()
    shape.radius = 8.0
    var collider = CollisionShape2D.new()
    collider.shape = shape
    add_child(collider)
    name = "DamageCollider"
    connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
    _lifetime_left -= delta
    if _lifetime_left <= 0.0:
        queue_free()




func _on_body_entered(body: Node) -> void:
    if body and body.has_node("SignalBus"):
        var bus = body.get_node("SignalBus") as SignalBus
        bus.emit_hit(damage_amount, self)
        print("Dealt ", damage_amount, " damage to ", body)
        queue_free()
