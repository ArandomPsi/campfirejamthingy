extends Node2D
@export var legreturnpos : Vector2
@export var maxdistance : int = 100
var going : bool = false


func _ready() -> void:
	get_child(0).visible = false

func _process(delta: float) -> void:
	if position.distance_to(get_parent().get_parent().position + (get_parent().get_parent().transform.x * legreturnpos.x) + (get_parent().get_parent().transform.y * legreturnpos.y)) > maxdistance and not going:
		going = true
		tweenlegpos()
	
	
func tweenlegpos():
	var tween = create_tween()
	var targetpos : Vector2 = get_parent().get_parent().position + (get_parent().get_parent().transform.x * legreturnpos.x) + (get_parent().get_parent().transform.y * legreturnpos.y)
	tween.tween_property(self,"position", targetpos,randf_range(0.1,0.25)).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	going = false
