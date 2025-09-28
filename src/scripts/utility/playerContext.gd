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
