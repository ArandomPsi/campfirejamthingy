extends Node

var playerpos : Vector2
var flash : float = 0
var room : int = 1
var shake : int = 0
var playerweapon : int = 0

func _process(delta):
	shake -= 1
	shake = clampi(shake,0,9999)
	flash = lerpf(flash,0.0,0.15)
