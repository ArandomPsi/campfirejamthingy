extends Node

var playerpos : Vector2
var flash : float = 0
var room : int = 0
var shake : float = 0
var playerweapon : int = 5
var trueroom : int = 0
var playerdead : bool = false

func _process(delta):
	shake -= delta * 120
	shake = clampi(shake,0,50)
	flash = lerpf(flash,0.0,0.15)
