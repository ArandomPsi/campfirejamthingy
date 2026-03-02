extends CharacterBody2D

var speed : int = 80
var friction : float = 0.8
var movedir : Vector2
var shotcooldown : float = 0

var shottype : int = 3
var shotcooldowns : Array = [15,40,5,100]
var stats : Array[float] = [1,1,1,1,1,1]
var prev_def_stat : int = 1
var prev_inv_stat : int = 1
#attack, defense, firerate, speed, amount of bullets, iframes

var base_hp : float = 5
var hp : float = base_hp
var maxhp : float = base_hp

var iframes : int = 60
var maxiframes : int = 50

var t : float

var roomalpha : float = 0

func _ready():
	shottype = global.playerweapon
	$hud/hudtransition.visible = true
	transitionin()

func _physics_process(delta):
	global.playerpos = position
	iframes -= 1
	statsstuff()
	if hp >= 1 and $hud/table.visible == false:
		controls()
	updateposition(delta)
	$sprite.rotation_degrees += 300 * delta
	hp = clampi(hp,0,maxhp)
	t += delta


func statsstuff():
	shotcooldown -= (1 + stats[2]) * (60/Engine.get_frames_per_second())
	if stats[1] > prev_def_stat:
		maxhp = base_hp + stats[1]
		prev_def_stat = stats[1]
		
	
	maxiframes = 50 + stats[5] * 8
	


func controls():
	movedir = Input.get_vector("left","right","up","down").normalized()
	if Input.is_action_pressed("shoot") and shotcooldown < 1 and iframes < (maxiframes / 4):
		shoot()
		shotcooldown = shotcooldowns[shottype]
	if $hud/table.visible:
		movedir = Vector2.ZERO

func updateposition(delta):
	velocity += movedir * speed * delta * 180 * stats[3]
	velocity *= friction
	
	$arrow.look_at(get_global_mouse_position())
	
	move_and_slide()
	
	$Camera2D.position = get_local_mouse_position() / 3
	var camshakebase = 2
	$Camera2D.offset = Vector2(randi_range(-camshakebase,camshakebase) * global.shake,randi_range(-camshakebase,camshakebase) * global.shake)
	$glowhud/hp.max_value = maxhp
	$glowhud/hp.value = lerpf($glowhud/hp.value,hp,0.2)
	
	$hud/title.modulate.a = roomalpha
	roomalpha = lerpf(roomalpha,0.0,0.05)
	
	
	if iframes > 1:
		$sprite.self_modulate.a = 0.5 * sin(t * 48) + 0.5
	else:
		
		$sprite.self_modulate.a = lerpf($sprite.self_modulate.a,1,0.15)
	

func shoot():
	
	match shottype:
		0:
			for i in range(int(1 * stats[4])):
				global.shake += 2
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.look_at(get_global_mouse_position())
				b.damage = 3 + stats[0] * 2
				get_tree().root.add_child(b)
		1:
			for i in range(int(8 * stats[4])):
				global.shake += 2
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.look_at(get_global_mouse_position())
				b.maxdistance = randi_range(30,40)
				b.damage = 2 + stats[0] * 2
				b.accuracy = 20
				b.speed *= randf_range(0.9,0.6) * 2
				get_tree().root.add_child(b)
		2:
			for i in range(int(1 * stats[4])):
				global.shake += 2
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.maxdistance = 80
				b.accuracy = 10
				b.damage = 1 + stats[0] * 2
				b.look_at(get_global_mouse_position())
				get_tree().root.add_child(b)
		3:
			for i in range(int(2 * stats[4])):
				global.shake += 4
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.speed = 2000
				b.dagger = true
				b.accuracy = 15
				b.damage = 10 + stats[0] * 2
				b.look_at(get_global_mouse_position())
				get_tree().root.add_child(b)


func damage(amount):
	if iframes < 1:
		hp -= amount
		global.flash = 0.5
		global.shake += 10
		iframes = maxiframes
		var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
		get_tree().root.add_child(b)
		b.modulate = $sprite.modulate
		b.position = global_position
		b.scale *= 2
		if hp < 1:
			iframes = 300000
			die()

func transition():
	global.flash = 1
	var tween = create_tween()
	tween.tween_method(transitionmat,0.0,2.0,0.2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Camera2D,"zoom",Vector2(10,10),0.2)
	tween.tween_method(transitionmat,2.0,0.0,0.2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Camera2D,"zoom",Vector2(1,1),0.2)
	$hud/title.text = "ROOM - " + str(global.trueroom)
	roomalpha = 5

func transitionmat(value : float):
	$hud/transition.material.set_shader_parameter("dir",Vector2(0,value))

func finished():
	var timer = get_tree().create_timer(0.8)
	await timer.timeout
	$hud/table/crt.visible = false
	var tween = create_tween()
	tween.tween_property($hud/table,"scale",Vector2(10,10),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(circtrans,0.0,1.0,0.2)
	await tween.finished
	$hud/table.visible = false
	transitionin()

func showupgrades():
	$hud/hudtransition.visible = true
	transitionout()
	
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	$hud/hudtransition.visible = false
	$hud/table.scale = Vector2(10,10)
	$hud/table.visible = true
	var tween = create_tween()
	tween.tween_property($hud/table,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$hud/table/crt.visible = true
	$hud/table/upgrade1.chooseupgrade()
	$hud/table/upgrade2.chooseupgrade()
	$hud/table/upgrade3.chooseupgrade()
	
	


func transitionin():
	$hud/hudtransition.visible = true
	var tween = create_tween()
	tween.tween_method(circtrans,1.0,0.0,0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	

func transitionout():
	$hud/hudtransition.visible = true
	var tween = create_tween()
	tween.tween_method(circtrans,0.0,1.0,0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	

func circtrans(value:float):
	$hud/hudtransition.material.set_shader_parameter("progress",value)

func die():
	$sounds/glitch.play(1)
	$glowhud/gameover.visible = true
	$hud/glitches.visible = true
	$glowhud/gameover.modulate.a = 0
	var tween = create_tween()
	$sounds/song.stop()
	tween.tween_property($glowhud/gameover,"modulate",Color(1,1,1,1),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_method(glitchesproperty,0.067,-0.004,0.5)
	tween.tween_interval(3)
	await tween.finished
	transitionout()
	var timer = get_tree().create_timer(1.5)
	await timer.timeout
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func glitchesproperty(value:float):
	$hud/glitches.material.set_shader_parameter("noiseIntensity",value)
