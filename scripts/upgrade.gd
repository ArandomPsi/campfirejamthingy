extends Button
var upgrades : Array = ["+atk","+def","+fra","+spd","+sps","+inv"]
var upgrade : int = 0

func _ready():
	scale = Vector2.ZERO

func chooseupgrade():
	scale = Vector2.ZERO
	upgrade = randi_range(0,upgrades.size() - 1)
	text = upgrades[upgrade]
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.5)

func finished():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(0,0),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.2)


func _on_pressed():
	get_parent().get_parent().get_parent().stats[upgrade] += 1
	finished()


