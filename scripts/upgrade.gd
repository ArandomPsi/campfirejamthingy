extends Button
var upgrades : Array = [
"+attack",
"+defense",
"+firerate",
"+speed",
"+amount",
"+iframes",
"lifesteal",
"special ability"
]
var ability_names : Array = ["Peas in a Pod", "Firecracker", "Buttered Up", "Bannana Curves", "Ripsaw Man", "Feel the Burn"]
var upgrade : int = 0

func _ready():
	scale = Vector2.ZERO

func chooseupgrade():
	scale = Vector2.ZERO
	if randf() < 0.01:
		upgrade = randi_range(6, 7)
		if upgrade == 7 and not global.ability:
			upgrades[7] = ability_names[global.playerweapon]
		else:
			upgrade = 6
	else:
		upgrade = randi_range(0,5)
	text = upgrades[upgrade]
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.5)

func finished():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(0,0),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.2)


func _on_pressed():
	get_parent().get_parent().get_parent().stats[upgrade] += 0.5
	finished()
