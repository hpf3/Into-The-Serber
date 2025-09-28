extends Button
@export
var scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    assert(scene != null, "ButtonToScene.scene not set")
    if not is_connected("pressed", Callable(self, "_on_pressed")):
        connect("pressed", Callable(self, "_on_pressed"))


func _on_pressed() -> void:
    if scene.can_instantiate():
        get_tree().change_scene_to_packed(scene)
