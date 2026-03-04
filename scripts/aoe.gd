extends Node2D


#keep aoe scale at 0

#log can you balance TS

func _ready():
	var tween = create_tween()
	tween.tween_property($warning,"self_modulate",Color(1,1,1,1),0.1)
	tween.tween_property($warning,"self_modulate",Color(1,1,1,0),0.4)
	tween.tween_property($aoe, "scale", Vector2(1.5,1.5),0.2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($aoe,"modulate",Color(1,1,1,0),0.2)
	await tween.finished
	queue_free()


func _on_area_2d_body_entered(body):
	body.damage(2)
