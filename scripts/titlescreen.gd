extends Control
var t : float
var currentweaponthingy : int = 0
var currentweaponthingytext : Array = [">Peashooter OS \n --the basic all rounder os",
">Point Blank OS \n --Kamakazi go brrr",
">Rayul OS \n --BRRRRRRRRRRRRRR",
">Thorfinn OS \n Gifted by the fathers",]

var pressed : bool = false

func _ready():
	updateepsteinfiles()

func _process(delta):
	$monitor/PointLight2D.energy = randf_range(0.45,0.5)
	$Lamp/PointLight2D.energy = randf_range(0.1,0.14)
	currentweaponthingy = clampi(currentweaponthingy,0,3)
	$Ps5/down/PointLight2D3.visible = true
	$Ps5/up/PointLight2D2.visible = true
	if currentweaponthingy == 0:
		$Ps5/down/PointLight2D3.visible = false
	if currentweaponthingy == 3:
		$Ps5/up/PointLight2D2.visible = false
	t += delta
	if not $Ps5/Button.is_hovered():
		$Ps5/Button/PointLight2D.texture_scale = (0.5 * sin(t * 5) + 0.5)/2
	else:
		$Ps5/Button/PointLight2D.texture_scale = 0.69
	
	if not pressed:
		$Camera2D.position = get_global_mouse_position()
	
	

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
	
