extends Node2D
@export var legreturnpos : Vector2
@export var maxdistance : int = 30


func _process(delta: float) -> void:
	if position.distance_to(get_parent().get_parent().position) > maxdistance:
		position = legreturnpos
	
