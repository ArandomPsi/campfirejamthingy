extends Line2D
@export var node1 : Node2D
@export var node2 : Node2D


func _process(delta: float) -> void:
	clear_points()
	add_point(node1.position)
	add_point(node2.position)
