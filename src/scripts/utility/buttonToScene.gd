extends Button
@export
var scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if scene.can_instantiate():
		get_tree().change_scene_to_packed(scene); # Replace with function body.
