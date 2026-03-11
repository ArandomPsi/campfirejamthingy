extends Node2D

signal wp
signal ap
signal sp
signal dp
signal lp
signal mp
signal bp
signal pp

var portalopened : bool = false
var portalsentered : int = 0

var bugs : Array = [preload("res://scenes/bugs/basicbug.tscn"),preload("res://scenes/bugs/combuster.tscn"),preload("res://scenes/bugs/bee.tscn"),preload("res://scenes/bugs/millipede.tscn"), preload("res://scenes/bugs/scorpion.tscn"), preload("res://scenes/bugs/spooder.tscn")]

var texts : Array[String] = [
	"--Antivirus Installation Complete--",
	"You are controlling an antivirus beneath the surface to wipe out all of the bugs that breached your CRT Monitor",
	"To switch Operating Systems(weapons), press the glowing red arrows on your console. \n [Must Satisfy OS Requirements]",
	"To enter the antivirus program into your corrupted CRT monitor, press the power button with a selected OS.",
	"This is the antivirus. \n Press the WASD keys to move it",
	"Left Click/Hold to Shoot. \n Aim with the crosshair",
	"In the top left corner is your health bar",
	"Some enemies damage on contact.",
	"Shoot the enemy until it's defeated",
	"Some enemies don't damage on contact, but instead shoot.",
	"Shoot the enemy until it's defeated",
	"Below is a warning symbol: ",
	"It doesn't do damage but an explosion appears shortly after.",
	"There is a rare chance for enemies to have enhancements, which give them extra abilities.",
	"Defeat this enhanced enemy",
	"This is an upgrade chip. Go on it, then select an upgrade.",
	"There are very rare special upgrades you can obtain too.",
	"Here is a collection of all enemies and upgrades: ",
	"Enemies: \n Beetle - Melee, Basic \n Puker - Ranged, Spread \n Bee - Melee, Dash \n Centipede - Ranged, Assault \n Scorpion - Ranged, Linear \n Spider - Ranged, Spiral \n [Click to Continue]",
	"Upgrades: Attack(damage), Defense(health), Firerate(shooting speed), Amount(of shots), Speed(Movement), Iframes(time of invinciblity upon getting damaged), Lifesteal(Rare), Ability(Rare with Unique Name), Explode(Rare) \n [Click to Continue]",
	"Above and below are portals. Go on them to enter a new room. Different portals have different rooms.",
	"Here's a practice room. Good Luck!",
	""
]
enum I {W, A, S, D, L, M, K, N}
var cur_text : int = 0

var getsit : bool = false
var triggered : bool = false

func _ready():
	await fade_tween(1.5, I.N)
	await fade_tween(4.5, I.N)
	await fade_tween(0, I.N)
	buttonable(true)
	await bp
	buttonable(false)
	await fade_tween(0, I.N)
	power_pear(true)
	await $GUI/Button.pressed
	power_pear(false)
	var p = preload("res://scenes/player.tscn").instantiate()
	p.global_position = Vector2(663.0, 531.0)
	$Camera2D.queue_free()
	add_child(p)
	await fade_tween(0, I.M)
	await fade_tween(0, I.L)
	await fade_tween(2.0, I.N)
	await fade_tween(1.5, I.N)
	await fade_tween(0, I.N)
	var b = bugs[0].instantiate()
	b.global_position = $TutorialText.global_position + Vector2(100, 0)
	add_child(b)
	await b.killed
	await fade_tween(2.0, I.N)
	await fade_tween(0, I.N)
	var c = bugs[1].instantiate()
	c.global_position = $TutorialText.global_position + Vector2(100, 0)
	add_child(c)
	await c.killed
	$"GUI/Warning Symbol".visible = true
	await fade_tween(1.5, I.N)
	await fade_tween(2.5, I.N)
	$"GUI/Warning Symbol".visible = false
	await fade_tween(2.5, I.N)
	await fade_tween(0.0, I.N)
	var d = bugs[0].instantiate()
	d.global_position = $TutorialText.global_position + Vector2(100, 0)
	add_child(d)
	var e = preload("res://scenes/bugs/enemyenhancements.tscn").instantiate()
	d.add_child(e)
	await d.killed
	await fade_tween(0.0, I.N)
	$upgradeportal.appear()
	await p.upgrade_selected
	await get_tree().create_timer(0.5).timeout
	await fade_tween(2.0, I.N)
	await fade_tween(1.5, I.N)
	await fade_tween(0.0, I.L)
	await fade_tween(0.0, I.L)
	await fade_tween(0.0, I.N)
	$buffer.queue_free()
	openportal()
	$upgradeportal.visible = false
	await pp
	await fade_tween(1.5, I.N)
	
	$portal1.modulate = Color(1,1,1,0)

func buttonable(b : bool):
	$GUI/up.disabled = not b
	$GUI/down.disabled = not b
	$GUI/up.visible = b
	$GUI/down.visible = b

func power_pear(b : bool):
	$GUI/Button.disabled = not b
	$GUI/Button.visible = b

func _process(delta):
	if not portalopened and not $enemychecker.has_overlapping_bodies() and getsit and not triggered:
		portal_delay()
		triggered = true
	
	if $GUI/up.button_pressed or $GUI/down.button_pressed:
		bp.emit()
		
	if $enemychecker.has_overlapping_bodies():
		portalopened = false
		$portal1.modulate = Color(1,1,1,0)
		$TileMap.modulate = lerp($TileMap.modulate,Color("ff7aad"),0.05)
	else:
		$TileMap.modulate = lerp($TileMap.modulate,Color("00a9ff"),0.05)
		
	
	$portal1/Area2D/CollisionShape2D.disabled = not portalopened
	$portal1/Area2D/CollisionShape2D2.disabled = $portal1/Area2D/CollisionShape2D.disabled
	
	if Input.is_action_just_released("shoot"):
		getsit = true
	

func portal_delay():
	openportal()
	await get_tree().create_timer(1.5).timeout
	portalopened = true
	print("hi")

func openportal():
	var tween = create_tween()
	tween.tween_property($portal1,"modulate",Color(1,1,1,1),0.5)

func _on_area_2d_body_entered(body):
	portalsentered += 1
	if portalsentered == 2:
		get_tree().change_scene_to_packed(preload("res://scenes/titlescreen.tscn"))
		return
	pp.emit()
	triggered = false
	global.totalrooms += 1
	$player.transition()
	$player.hp = $player.maxhp
	var timer = get_tree().create_timer(0.3)
	$upgradeportal.visible = false
	$player.position = Vector2(1344/2,806/2)
	global.room = clampi(global.room,1,10)
	await timer.timeout
	for i in range(2):
		var r = randi_range(0, 1)
		var b = bugs[r].instantiate()
		b.position.x = randi_range(100,1320)
		b.position.y = randi_range(20,648)
		add_child(b)
			
			
			
		
	
	global.save(true)
	global.trueroom += 1
	global.room += randi_range(0,1.5) #5- percent chance of scaling up

func upgradething(trick): #for signal
	$player.showupgrades()

func fade_tween(wait : float, sig : I):
	var tween = create_tween()
	tween.tween_property($TutorialText, "modulate:a", 0, 0.5)
	tween.parallel().tween_property($TutorialText, "visible_ratio", 0, 0.49)
	await tween.finished
	$TutorialText.text = texts[cur_text]
	cur_text += 1
	var tween2 = create_tween()
	tween2.tween_property($TutorialText, "modulate:a", 1, 0.5)
	tween2.parallel().tween_property($TutorialText, "visible_ratio", 1, 0.49)
	await tween2.finished
	if wait > 0:
		await get_tree().create_timer(wait).timeout
	elif sig != I.N:
		await match_signal(sig)
			

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		wp.emit()
	elif event.is_action_pressed("left"):
		ap.emit()
	elif event.is_action_pressed("down"):
		sp.emit()
	elif event.is_action_pressed("right"):
		dp.emit()
	elif event.is_action_pressed("shoot"):
		lp.emit()
	if event.is_action_pressed("up") or event.is_action_pressed("left") or event.is_action_pressed("down") or event.is_action_pressed("right"):
		mp.emit()
	
	
func match_signal(sig : I):
	var s : Signal
	match sig:
		I.W:
			s = wp
		I.A:
			s = ap
		I.S:
			s = sp
		I.D:
			s = dp
		I.L:
			s = lp
		I.M:
			s = mp
		_:
			print("tutorial signal error")
	return s
