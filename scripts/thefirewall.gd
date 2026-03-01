extends Node2D

var attacks : Array = []
var hp : int = 1000



func _process(delta):
	if not $attackplayer.is_playing():
		$attackplayer.play(attacks.pick_random())
