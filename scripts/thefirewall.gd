extends Node2D

signal clicked

var attacks : Array = ["flashfire", "enemy", "fireball"]
var hp : int = 7500
var buffer : bool = true
var etimer : float = 0.0
var dead : bool = false

func _ready():
	randomize()
	global.boss_battle = true
	for i in range(10):
		await get_tree().process_frame
	await dialogue_scene()


func _process(delta):
	if get_tree().paused or buffer:
		var camshakebase = 2
		$Dialogue.offset = Vector2(randi_range(-camshakebase,camshakebase) * global.shake,randi_range(-camshakebase,camshakebase) * global.shake)
	else:
		etimer += delta
		if not $attackplayer.is_playing():
			$attackplayer.play(attacks.pick_random())
		if global.playerdead:
			queue_free()

func spawnflashfire():
	var b = preload("res://scenes/bugs/f_lash_fire_attack.tscn").instantiate()
	get_tree().root.add_child(b)
	b.position = Vector2.ZERO

func spawnfireball():
	for i in range(randi_range(2, 4)):
		var b = preload("res://scenes/bugs/fireball.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = $Marker2D.position
		b.position.x += randi_range(-500,500)
		b.look_at(global.playerpos)
		b.rotation_degrees += randi_range(-64, 64)

func spawnrandomenemy():
	for i in range(randi_range(1, 3)):
		var bugs : Array = [preload("res://scenes/bugs/basicbug.tscn"),preload("res://scenes/bugs/combuster.tscn"),preload("res://scenes/bugs/bee.tscn"),preload("res://scenes/bugs/millipede.tscn"), preload("res://scenes/bugs/scorpion.tscn"), preload("res://scenes/bugs/spooder.tscn")]
		var b = bugs.pick_random().instantiate()
		b.position.x = randi_range(100,1320)
		b.position.y = randi_range(20,648)
		get_tree().root.add_child(b)

func burn(amount):
	for i in range(5):
		var c = preload("res://scenes/vfx/flaming.tscn").instantiate()
		add_child(c)
		c.emitting = true
		c.global_position = global_position
		damage(amount)
		await get_tree().create_timer(1.0).timeout

func damage(amount):
	hp -= amount
	if hp < 0 and not dead:
		dead = true
		if etimer <= 45.0:
			await easter_egg()
		var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
		get_tree().root.add_child(b)
		b.modulate = Color("#ff0095")
		b.scale *= 2
		global.boss_battle = false
		queue_free()

func dialogue_scene():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasModulate.visible = true
	$Dialogue.visible = true
	get_tree().paused = true
	await fade_panel(false)
	await txtween("Antivirus: Oh, hey firewall!", true, 1.1)
	await txtween("Firewall: Hey, antivirus! Oh, and thanks for falling straight into my trap...", false, 1.2)
	await txtween("Antivirus: That's not a very good joke.", true, 1.1)
	await txtween("Firewall: Oh you wish I was joking, but it's time to put an end to you FOREVER!", false, 1.3)
	$Dialogue/PlayerPanel/Sprite2D.texture = preload("res://assets/playermad.svg")
	await txtween("Antivirus: What are you talking about? Aren't you my friend?", true, 1.2)
	await txtween("Firewall: That was all a lie because beneath the surface I'm EVIL!", false, 1.2)
	await txtween("Firewall: Did you think I was keeping the bugs and viruses away? Hahaha, nope.", false, 1.3)
	await txtween("Firewall: I'VE BEEN IN CONTROL THE ENTIRE TIME AND SENDING THEM AFTER YOU!!", false, 1.5)
	await txtween("Antivirus: Then I'll just have to put an end to you!", true, 1.3)
	await txtween("", true, 1)
	$CanvasModulate.visible = false
	get_tree().paused = false
	buffer = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func easter_egg():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	buffer = true
	$CanvasModulate.visible = true
	$Dialogue.visible = true
	get_tree().paused = true
	await fade_panel(false)
	$Sounds/EasterEggSFX.play()
	await txtween("Antivirus: None of you seem to understand...", true, 1.02)
	await txtween("Antivirus: I'm not locked In HerE WiTH YoU!", true, 1.2)
	await txtween("Antivirus: YoU'RE LOCKED IN HERE WITH ME!!!", true, 1.4)
	await txtween("[You found an easter egg!]", true, 1)
	await txtween("", true, 1)
	$CanvasModulate.visible = false
	get_tree().paused = false
	buffer = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func txtween(t : String, anti : bool, strength : float):
	var tween = create_tween()
	var i = t.length() / 20
	tween.tween_property($Dialogue/Label, "visible_ratio", 0.0, 0.8)
	await tween.finished
	var cc = "\n[Click to Continue]" if t.length() > 0 else ""
	$Dialogue/Label.text = t + cc
	var c = "#ff95be" if not anti else "#42b1ff"
	$Dialogue/PlayerPanel.visible = anti
	$Dialogue/FirewallPanel.visible = not anti
	$Dialogue/Label.modulate = Color(c)
	soundsthingy(len(t), i)
	var tween2 = create_tween()
	if $Sounds/EasterEggSFX.stream_paused:
		$Sounds/EasterEggSFX.stream_paused = false
	tween2.tween_property($Dialogue/Label, "visible_ratio", 1.0, i)
	tween2.parallel().tween_property(global, "shake", t.length() / 7 * strength, i)
	await tween2.finished
	if $Sounds/EasterEggSFX.playing:
		$Sounds/EasterEggSFX.stream_paused = true
	if t.length() > 0:
		await clicked
	else:
		await fade_panel(true)

func fade_panel(out : bool):
	var t = 0.0 if out else 1.0
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).parallel()
	tween.tween_property($Dialogue/PlayerPanel, "modulate:a", t, 0.49)
	tween.tween_property($Dialogue/FirewallPanel, "modulate:a", t, 0.49)
	await tween.finished
	$Dialogue.visible = not out

func soundsthingy(amount : int, time : float):
	for i in range(amount / 1.5):
		var b = preload("res://scenes/sounds/infothingy.tscn").instantiate()
		b.volume_db = 0.0
		add_child(b)
		var timer = get_tree().create_timer(time/amount * 1.5)
		await timer.timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		clicked.emit()
