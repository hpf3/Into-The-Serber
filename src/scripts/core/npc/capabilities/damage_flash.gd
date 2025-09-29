extends NpcCapability

# Flashes the host's visuals when damage is taken.
@export var visual_node_path: NodePath
@export var flash_color: Color = Color(1.0, 0.45, 0.45, 1.0)
@export_range(0.01, 1.0, 0.01) var flash_duration: float = 0.12

var _target: CanvasItem
var _base_modulate: Color = Color.WHITE
var _active_tween: Tween

func _on_attached() -> void:
    _target = _resolve_target()
    if _target:
        _base_modulate = _target.modulate
    else:
        push_warning("DamageFlash did not find a CanvasItem to tint.")
    _connect_if("damaged", "_on_damaged")


func _on_detached() -> void:
    if _active_tween:
        _active_tween.kill()
        _active_tween = null
    if _target:
        _target.modulate = _base_modulate
    _target = null


func get_npc_data(_key: int) -> Variant:
    return null


func _on_damaged(_amount: float, _hp_cur: float, _hp_max: float, _source: Node) -> void:
    _play_flash()


func _play_flash() -> void:
    if _target == null:
        return

    if _active_tween:
        _active_tween.kill()

    _target.modulate = flash_color

    var tween := _target.create_tween()
    _active_tween = tween
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(_target, "modulate", _base_modulate, flash_duration)
    tween.finished.connect(_on_tween_finished)


func _on_tween_finished() -> void:
    _active_tween = null
    if _target:
        _target.modulate = _base_modulate


func _resolve_target() -> CanvasItem:
    if host and host is CanvasItem and visual_node_path.is_empty():
        return host

    var node: Node = null

    if not visual_node_path.is_empty():
        node = get_node_or_null(visual_node_path)
        if node == null and host:
            node = host.get_node_or_null(visual_node_path)
        if node and node is CanvasItem:
            return node
        if node and not (node is CanvasItem):
            push_warning("Node at path '%s' is not a CanvasItem." % visual_node_path)

    if host:
        var canvas_host := host if host is CanvasItem else null
        if canvas_host:
            return canvas_host
        return _find_canvas_child(host)

    return _find_canvas_child(self)


func _find_canvas_child(root: Node) -> CanvasItem:
    for child in root.get_children():
        if child is CanvasItem:
            return child
        var nested := _find_canvas_child(child)
        if nested:
            return nested
    return null
