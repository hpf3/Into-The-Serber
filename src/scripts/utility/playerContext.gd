class_name PlayerContext
extends Object

var player: CharacterBody2D
var stats: Stats

var position: Vector2:
    get:
        return player.position
    set(value):
        player.position = value

var velocity: Vector2

var aim_direction: Vector2

static func new_from_player(player: CharacterBody2D, stats: Stats, velocity: Vector2, aim_direction: Vector2) -> PlayerContext:
    var context := PlayerContext.new()
    context.player = player
    context.stats = stats
    context.velocity = velocity
    context.aim_direction = aim_direction
    return context
