class_name Player
extends CharacterBody2D

@onready var stats: Stats = $%Stats
# Mark Abilities/Primary/Secondary/Passive as "Unique Name in Owner" in the editor.
@export() var sprite_frames: CompressedTexture2DArray = preload("res://art/characters_spritesheet.png")
@export var movement: PlayerMovement = PlayerMovement.new()
#region Scene Events
func _ready() -> void:
	_assertions()
	if movement == null:
		movement = PlayerMovement.new()
	set_sprite_frame(0, false) #default to down


func _physics_process(delta: float) -> void:
	movement.apply(self, stats, delta)
	move_and_slide()
	set_sprite_from_vec(velocity)
	_process_abilities()
#endregion





#region Abilities

func _process_abilities() -> void:
	var state := PlayerContext.new()
	state.player = self
	state.stats = stats
	state.velocity = velocity

	if Input.is_action_just_pressed("ability_primary"):
		_trigger_folder("%Primary", state)
	if Input.is_action_just_pressed("ability_secondary"):
		_trigger_folder("%Secondary", state)
	if Input.is_action_just_pressed("ability_dash"):
		_trigger_folder("%Dash", state)
	_trigger_folder("%Passive",state)

func _trigger_folder(unique_path: String, state: PlayerContext) -> void:
	var folder := get_node_or_null(unique_path)
	if folder == null: return
	var abilities := _collect_abilities(folder)
	for a: Ability in abilities:
		if a.can_trigger(state):
			var pre := a.get_cooldown_left()
			a.trigger(state)
			if pre <= 0.0 and a.get_cooldown_left() <= 0.0 and a.get_cooldown() > 0.0:
				a.start_cooldown()

func _collect_abilities(root: Node) -> Array[Ability]:
	var out: Array[Ability] = []
	_collect_recursive(root, out)
	# Stable ordering: priority, then name
	out.sort_custom(func(a, b):
		if a.priority == b.priority:
			return a.name < b.name
		return a.priority < b.priority
	)
	return out

func _collect_recursive(n: Node, out: Array) -> void:
	if n is Ability:
		out.append(n)
	for c in n.get_children():
		_collect_recursive(c, out)
#endregion





#region Sprite Handling
func set_sprite_frame(idx: int, mirror: bool) -> void:
	var spr := $%Image as Sprite2D
	var image = sprite_frames.get_layer_data(idx)
	if mirror:
		image.flip_x()
	spr.texture = ImageTexture.create_from_image(image)

func set_sprite_from_vec(vec: Vector2) -> void:
	if vec.is_zero_approx():
		return

	var normalized := vec.normalized()
	var best_dir := Vector2.DOWN
	var best_dot := -2.0
	var dirs := [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]

	for dir in dirs:
		var dot := normalized.dot(dir)
		if dot > best_dot:
			best_dot = dot
			best_dir = dir

	var sprite_idx := 0
	var mirror := false

	if best_dir == Vector2.UP:
		sprite_idx = 1
	elif best_dir == Vector2.LEFT:
		sprite_idx = 2
	elif best_dir == Vector2.RIGHT:
		sprite_idx = 2
		mirror = true

	set_sprite_frame(sprite_idx, mirror)
#endregion




func _assertions() -> void:
	assert((get_node_or_null("%Abilities") as Node) != null, "Missing %Abilities under Player")
	assert((get_node_or_null("%Primary") as Node)  != null, "Missing %Primary under Abilities")
	assert((get_node_or_null("%Secondary") as Node)!= null, "Missing %Secondary under Abilities")
	assert((get_node_or_null("%Passive") as Node)  != null, "Missing %Passive under Abilities")
	assert((get_node_or_null("%Dash") as Node)  != null, "Missing %Dash under Abilities")
	assert((get_node_or_null("%Stats") as Stats) != null, "%Stats is missing or not a Stats node")
	assert(sprite_frames != null and sprite_frames.get_layers() == 3, "Player sprite_frames not set up")
	assert((get_node_or_null("%Image") as Sprite2D) != null, "Missing %Sprite2D under Player")
