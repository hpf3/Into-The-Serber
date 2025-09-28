# NpcContracts.gd
class_name NpcContracts

# Event names are still useful constants (StringName), but signals are typed.
const EVT_INIT  := &"init"
const EVT_TICK  := &"tick"
const EVT_HIT   := &"hit"
const EVT_DAMAGED := &"damaged"
const EVT_DIED  := &"died"

# Data keys (typed via enum)
enum DataKey { HP_CUR, HP_MAX }
