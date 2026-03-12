extends Button

@onready var p = get_parent().get_parent().get_parent()
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
var ability_names : Array = ["Peas in a Pod", "Target Locked", "Buttered Up", "Bannana Curves", "Ripsaw Man", "Feel the Burn"]
var ability_desc : Array = [
	"Shoot 2 mega projectiles every now and then.",
	"All projectiles go towards the nearest target at the time of shooting for the entire lifetime of the projectile.",
	"Every once in a while, shoot double the bullets with extreme spread.",
	"All projectiles release 5 mini daggers [upon collision] that curve.",
	"When charging up the laser, gain a melee saw that charges up.",
	"Enemies take burning damage upon being hit."
]
var upgrade : int = 0

func _ready():
	scale = Vector2.ZERO

func chooseupgrade():
	scale = Vector2.ZERO
	if randf() < 0.5:
		upgrade = randi_range(6, 7)
		if upgrade == 7 and not global.ability:
			upgrades[7] = ability_names[global.playerweapon]
		else:
			upgrade = 6
	else:
		upgrade = randi_range(0,5)
	text = upgrades[upgrade]
	set_tooltip_txt()
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.5)

func finished():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,0.1),0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(0,0),0.3).set_trans(Tween.TRANS_CUBIC).set_delay(0.2)


func _on_pressed():
	p.stats[upgrade] += 0.5
	p.upgrade_selected.emit()
	finished()

func set_tooltip_txt():
	var s : String
	match upgrade:
		0:
			s = "The attack stat improves the antivirus' damage. \n Current Attack Stat: "
		1:
			s = "The defense stat improves the antivirus' health. \n Current Defense Stat: "
		2:
			s = "The firerate stat improves the antivirus' speed to shoot again. \n Current Firerate Stat: "
		3:
			s = "The speed stat improves the antivirus' movement speed. \n Current Speed Stat: "
		4:
			s = "The amount stat improves the antivirus' projectiles per shot. \n Current Amount Stat: "
		5:
			s = "The iframes stat improves the antivirus' time of invincibility upon getting hit or entering a new room. \n Current Iframes Stat: "
		6:
			s = "Lifesteal is a rare upgrade that grants/improves the ability of having a chance to gain health upon dealing damage. \n Current Lifesteal Stat: "
		7:
			s = "This is a special [one-time] ability unique to the current OS(weapon)! \n " + upgrades[7] + ": " + ability_desc[global.playerweapon]
			
	var ss : String = str(p.stats[upgrade]) if upgrade != 7 else ""
	tooltip_text = s + ss
