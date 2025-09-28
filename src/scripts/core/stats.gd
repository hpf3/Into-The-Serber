class_name Stats
extends Node
const SD = preload("res://scripts/enums/stat_defs.gd")
@export_custom(PROPERTY_HINT_TYPE_STRING, SD.Export_Hint) var base_dict: Dictionary = SD.DEFAULT_BASE_DICT

var base: Array[float] = []               # canonicalized at runtime
var _flat: Array[float] = []
var _pct_add: Array[float] = []
var _mul: Array[float] = []

func _ready() -> void:
	base = _canonicalize_base(base_dict)
	_flat.resize(SD.N); _pct_add.resize(SD.N); _mul.resize(SD.N)
	for i in SD.N:
		_flat[i] = 0.0; _pct_add[i] = 0.0; _mul[i] = 1.0

func _canonicalize_base(dict_in: Dictionary) -> Array[float]:
	var out: Array[float] = []
	out.resize(SD.N)
	for i in SD.N:
		var stat := SD.get_stat(i)
		if stat in dict_in:
			out[i] = float(dict_in[stat])
		else:
			out[i] = SD.DEFAULT_BASE_DICT[stat]
	return out

func begin() -> void:
	for i in SD.N:
		_flat[i] = 0.0
		_pct_add[i] = 0.0
		_mul[i] = 1.0

func add_flat(stat: SD.Stat, amount: float) -> void:
	_flat[int(stat)] += amount

func add_pct(stat: SD.Stat, amount: float) -> void:
	_pct_add[int(stat)] += amount

func add_mult(stat: SD.Stat, factor: float) -> void:
	_mul[int(stat)] *= factor

func get_stat(stat: SD.Stat) -> float:
	var i := int(stat)
	return (base[i] + _flat[i]) * (1.0 + _pct_add[i]) * _mul[i]

func recompute(abilities_root: Node, state: Dictionary) -> void:
	begin()
	_collect_mods_recursive(abilities_root, state)

func _collect_mods_recursive(n: Node, state: Dictionary) -> void:
	if n.has_method("collect_stat_modifiers"):
		n.collect_stat_modifiers(self, state)
	for c in n.get_children():
		_collect_mods_recursive(c, state)


# Computed properties for easy access
var move_speed: float:
	get:
		return get_stat(SD.Stat.MOVE_SPEED)
var max_hp: float:
	get:
		return get_stat(SD.Stat.MAX_HP)
var attack_speed: float:
	get:
		return get_stat(SD.Stat.ATTACK_SPEED)
var damage: float:
	get:
		return get_stat(SD.Stat.DAMAGE)
var defense: float:
	get:
		return get_stat(SD.Stat.DEFENSE)
var crit_chance: float:
	get:
		return get_stat(SD.Stat.CRIT_CHANCE)
var crit_power: float:
	get:
		return get_stat(SD.Stat.CRIT_POWER)
