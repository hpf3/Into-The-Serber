extends Ability

@export
var damage_amount: float = 10.0

func trigger(context: PlayerContext) -> void:
    if not can_trigger(context):
        return
    start_cooldown()
    var collider = DamageCollider.new()
    collider.damage_amount = damage_amount
    var pos = context.player.get_global_mouse_position()
    collider.position = pos
    context.player.get_parent().add_child(collider)
    print("Spawned damage collider at ", pos)
