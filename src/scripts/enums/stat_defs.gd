class_name StatDefs
const _key_hint = "2/2:Move Speed,Max HP,Attack Speed,Damage,Defense,Crit Chance, Crit Power" #TYPE_INT/PROPERTY_HINT_ENUM
const _value_hint = "3:"
const Export_Hint = _key_hint+";"+_value_hint

enum Stat {
	MOVE_SPEED,
	MAX_HP,
	ATTACK_SPEED, #ability cooldown mod
	DAMAGE, #ability damage mod
	DEFENSE, #damage reduction,(flat + %),min of 1
	CRIT_CHANCE,#chance of extra damage
	CRIT_POWER,#percentage increase of damage
	ERROR #here to catch out-of-bounds, do not use
}

const N: int = 7 #set to number of stats above, excluding ERROR

const NAMES: Array[StringName] = [
	"Move Speed","Max HP","Attack Speed","Damage,Defense","Crit Chance", "Crit Power"
]

const DEFAULT_BASE_DICT := {
	Stat.MOVE_SPEED: 220.0,
	Stat.MAX_HP: 100.0,
	Stat.ATTACK_SPEED: 1.0,
	Stat.DAMAGE: 10.0,
	Stat.DEFENSE: 0.0,
}

static func label(stat: Stat) -> String:
	return String(NAMES[int(stat)])

static func get_stat(num: int) -> Stat:
	match  num:
		0: return Stat.MOVE_SPEED
		1: return Stat.MAX_HP
		2: return Stat.ATTACK_SPEED
		3: return Stat.DAMAGE
		4: return Stat.DEFENSE
		5: return Stat.CRIT_CHANCE
		6: return Stat.CRIT_POWER
	return Stat.ERROR
	
