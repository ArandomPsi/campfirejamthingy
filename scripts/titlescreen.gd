extends Control
var t : float
var currentweaponthingy : int = 0
var currentweaponthingytext : Array = [
">Installation Program \n --Press power button to install antivirus",
">Peashooter OS \n --the basic all rounder os",
">Noob OS \n --Low Range, High Damage; Shotgun",
">Rayul OS \n --I NEED MOOER BOULETSS!!! Machine",
">Bannana Man OS \n --Gifted by the bannana man; Daggers",
">Ripper OS \n --3,2,1 let it rip! hold for damage; Laser",
">Arsonist OS \n --I watched the world burn; Flamethrower"]

var pressed : bool = false
var totalroomthingy : int = 10

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	currentweaponthingy = global.playerweapon
	global.trueroom = 0
	global.room = 0
	global.lifesteal = false
	global.ability = false
	$Camera2D.zoom = Vector2(20,20)
	var timer = get_tree().create_timer(3)
	await timer.timeout
	updateepsteinfiles()
	
	
	

func _process(delta):
	
	print(str(currentweaponthingy))
	#constant changes
	$monitor/PointLight2D.energy = randf_range(0.45,0.5)
	$Lamp2/PointLight2D.energy = randf_range(0.1,0.14)
	$Lamp2/PointLight2D2.energy = randf_range(3,3.2) * 1.5
	currentweaponthingy = clampi(currentweaponthingy,0,6)
	$Ps5/down/PointLight2D3.visible = true
	$Ps5/up/PointLight2D2.visible = true
	
	#if statments
	if currentweaponthingy == 0:
		$Ps5/down/PointLight2D3.visible = false
	if currentweaponthingy == len(currentweaponthingytext) - 1:
		$Ps5/up/PointLight2D2.visible = false
	t += delta
	if not $Ps5/Button.is_hovered():
		$Ps5/Button/PointLight2D.texture_scale = (0.5 * sin(t * 5) + 0.5)/2
	else:
		$Ps5/Button/PointLight2D.texture_scale = 0.69
	
	if not pressed:
		$Camera2D.position = get_global_mouse_position()
		$Camera2D.zoom = lerp($Camera2D.zoom,Vector2(1.15,1.15),0.1)
	
	if not $Ps5/up.is_hovered():
		$Ps5/up/PointLight2D2.energy = 0.93
	else:
		$Ps5/up/PointLight2D2.energy = 2.65
	
	if not $Ps5/down.is_hovered():
		$Ps5/down/PointLight2D3.energy = 0.93
	else:
		$Ps5/down/PointLight2D3.energy = 2.65

func _on_button_pressed():
	if not currentweaponthingy == 0:
		global.playerweapon = currentweaponthingy - 1
	elif not global.tutorialed:
		global.playerweapon = 0
	global.save(false)
	if currentweaponthingy == 0:
		pressed = true
		var tween = create_tween()
		tween.tween_property($Camera2D,"position",Vector2(826,257),0.5).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($Camera2D,"zoom",Vector2(15,15),0.8).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	elif global.totalrooms >= (currentweaponthingy - 1) * totalroomthingy:
		pressed = true
		var tween = create_tween()
		tween.tween_property($Camera2D,"position",Vector2(826,257),0.5).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($Camera2D,"zoom",Vector2(15,15),0.8).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		get_tree().change_scene_to_file("res://scenes/testmap.tscn")
	else:
		$error.play()


func _on_up_pressed():
	currentweaponthingy += 1
	updateepsteinfiles()


func _on_down_pressed():
	currentweaponthingy -= 1
	updateepsteinfiles()

func updateepsteinfiles():
	var tween = create_tween()
	tween.tween_property($Panel/thefiles,"visible_ratio",0.0,0.8)
	await tween.finished
	
	var bestroomtxt : String = "\n>Highest Room: " + str(global.bestroom)
	if global.totalrooms >= (currentweaponthingy - 1) * totalroomthingy: #check the total rooms
		$Panel/thefiles.text = currentweaponthingytext[currentweaponthingy] + bestroomtxt
	else:
		if currentweaponthingy == 0 and not global.tutorialed:
			$Panel/thefiles.text = ">ERROR \n --Antivirus Must be Installed!"
		else:
			$Panel/thefiles.text = ">DATA CORRUPTED - EXTERMINATE " + str((currentweaponthingy - 1) * totalroomthingy) + " WAVES TO DECORRUPT" + bestroomtxt
	var tween2 = create_tween()
	tween2.tween_property($Panel/thefiles,"visible_ratio",1.0,0.8)
	



func _on_offswitch_pressed():
	$Lamp2/PointLight2D.visible = not $Lamp2/PointLight2D.visible
	$Lamp2/PointLight2D2.visible =  $Lamp2/PointLight2D.visible
	if not $Lamp2/PointLight2D2.visible:
		var b = preload("res://scenes/vfx/jumpscare.tscn").instantiate()
		get_tree().root.add_child(b)
