extends Control
var t : float
var currentweaponthingy : int = 0
var currentweaponthingytext : Array = [">Peashooter OS \n --the basic all rounder os",
">Noob OS \n --Low Range, High Damage; 'Caesoh' -The average gen alpha kid",
">Rayul OS \n --spray 'n' pray",
">Thorfinn OS \n --Gifted by the bannana man",
">Ripper OS \n --3,2,1 let it rip! hold for damage"]

var pressed : bool = false

func _ready():
	global.trueroom = 0
	$Camera2D.zoom = Vector2(20,20)
	var timer = get_tree().create_timer(2)
	await timer.timeout
	updateepsteinfiles()
	

func _process(delta):
	
	#constant changes
	$monitor/PointLight2D.energy = randf_range(0.45,0.5)
	$Lamp2/PointLight2D.energy = randf_range(0.1,0.14)
	$Lamp2/PointLight2D2.energy = randf_range(3,3.2)
	currentweaponthingy = clampi(currentweaponthingy,0,4)
	$Ps5/down/PointLight2D3.visible = true
	$Ps5/up/PointLight2D2.visible = true
	
	#if statments
	if currentweaponthingy == 0:
		$Ps5/down/PointLight2D3.visible = false
	if currentweaponthingy == 4:
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
	global.playerweapon = currentweaponthingy
	pressed = true
	var tween = create_tween()
	tween.tween_property($Camera2D,"position",Vector2(826,257),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Camera2D,"zoom",Vector2(15,15),0.8).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/testmap.tscn")
	


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
	$Panel/thefiles.text = currentweaponthingytext[currentweaponthingy]
	var tween2 = create_tween()
	tween2.tween_property($Panel/thefiles,"visible_ratio",1.0,0.8)
	


func _on_offswitch_pressed():
	$Lamp2/PointLight2D.visible = not $Lamp2/PointLight2D.visible
	$Lamp2/PointLight2D2.visible =  $Lamp2/PointLight2D.visible
