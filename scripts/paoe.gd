extends Node2D

var dmg : int = 2
#keep aoe scale at 0

#log can you balance TS

func _ready():
	var tween = create_tween()
	tween.tween_property($aoe, "scale", Vector2(1.5,1.5),0.2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($aoe,"modulate",Color(1,1,1,0),0.2)
	await tween.finished
	queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(dmg)
		if not body.name == "player":
			createdamagenumber(dmg,body)

func createdamagenumber(amount,body : Node2D):
	var b = preload("res://scenes/vfx/damagelabel.tscn").instantiate()
	b.position = body.global_position
	b.damage = amount
	get_tree().root.add_child(b)
