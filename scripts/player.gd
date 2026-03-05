extends CharacterBody2D

var speed : int = 80
var friction : float = 0.8
var movedir : Vector2
var shotcooldown : float = 0

var shottype : int = 4
var shotcooldowns : Array = [15,50,5,50,0]
var stats : Array[float] = [1,1,1,1,1,1,1]
var specialshotcharge : float = 0
var prev_def_stat : float = 1
var prev_inv_stat : float = 1
var prev_spec_stat : float = 1
#attack, defense, firerate, speed, amount of bullets, iframes, special ability

var base_hp : float = 5
var hp : float = base_hp
var maxhp : float = base_hp

var iframes : int = 60
var maxiframes : int = 50

# special ability variables
var shot_num : int = 0
var shot_scale : int = 3
var shot_req : int = 15
var saw_dmg : int = 1
var saw_spd : float = 0.5
var saw_timer : float = 0.0
var cur_targs : Array = [] 

var t : float

var roomalpha : float = 0

func _ready():
	global.trueroom = 0
	shottype = global.playerweapon
	$hud/hudtransition.visible = true
	global.playerdead = false
	transitionin()

func _physics_process(delta):
	print(saw_timer)
	global.playerpos = position
	iframes -= 1
	statsstuff()
	if hp >= 1 and $hud/table.visible == false and not $upgradeportalchecker.has_overlapping_areas():
		controls(delta)
	else:
		movedir = Vector2.ZERO
	updateposition(delta)
	$sprite.rotation_degrees += 300 * delta
	hp = clampi(hp,0,maxhp)
	t += delta
	$crosshair.global_position = get_global_mouse_position()
	
	saw_timer -= delta
	if iframes > 1:
		saw_spd = 0.5
	if saw_timer <= 0.0:
		if cur_targs.size() > 0:
			for targ in cur_targs:
				saw(targ)
				print("sawing " + str(targ.name))
			saw_timer = saw_spd

func statsstuff():
	shotcooldown -= (1 + stats[2]) * (60/Engine.get_frames_per_second())
	if stats[1] > prev_def_stat:
		maxhp = base_hp + stats[1]
		prev_def_stat = stats[1]
		
	if stats[6] > prev_spec_stat:
		match shottype:
			0:
				if int(stats[6] * 10) % 10 == 5:
					shot_req -= 1
					shot_num = 0
				else:
					shot_scale += 0.5
			4:
				saw_dmg += 1
		prev_spec_stat = stats[6]
	
	maxiframes = 50 + stats[5] * 20
	


func controls(delta):
	
	#basic movement
	movedir = Input.get_vector("left","right","up","down").normalized()
	
	#shots and stuff
	match shottype:
		4:
			if Input.is_action_pressed("shoot") and iframes < 1:
				specialshotcharge += delta * 10 * stats[2]
				$arrow/charge.emitting = true
				if stats[6] > 1:
					$arrow/deltashot.modulate.a = specialshotcharge / 20
					$arrow/deltashot.rotation_degrees += specialshotcharge / 2
					saw_spd -= delta / 30
					saw_spd = clamp(saw_spd, 0.01, 0.5)
					$arrow/deltashot/hitbox/dscoll.disabled = false
			if Input.is_action_just_released("shoot"):
				$arrow/charge.emitting = false
				shoot()
				specialshotcharge = 0
				saw_spd = 0.5
				$arrow/deltashot.modulate.a = 0
				$arrow/deltashot/hitbox/dscoll.disabled = true
		3,2,1,0:
			if Input.is_action_pressed("shoot") and shotcooldown < 1 and iframes < (maxiframes / 4):
				shoot()
				shotcooldown = shotcooldowns[shottype]
	
	#no moving while the upgrade
	if $hud/table.visible:
		movedir = Vector2.ZERO
	
	
	

func updateposition(delta):
	velocity += movedir * speed * delta * 180 * (1+(stats[3]-1)*0.2)
	velocity *= friction
	
	$arrow.look_at(get_global_mouse_position())
	
	move_and_slide()
	
	
	
	#the misc things
	$Camera2D.position = get_local_mouse_position() / 3
	var camshakebase = 2
	$Camera2D.offset = Vector2(randi_range(-camshakebase,camshakebase) * global.shake,randi_range(-camshakebase,camshakebase) * global.shake)
	$glowhud/hp.max_value = maxhp
	$glowhud/hp.value = lerpf($glowhud/hp.value,hp,0.2)
	
	$hud/title.modulate.a = roomalpha
	roomalpha = lerpf(roomalpha,0.0,0.05)
	
	
	if $arrow/charge.emitting:
		$arrow/charge.position.x = 50
		$arrow/charge.speed_scale = 1 + specialshotcharge * 0.05
	
	
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
				if shot_num == shot_req and stats[6] > 1:
					b.scale = Vector2(shot_scale, shot_scale)
					b.speed = 800 - 100 * shot_scale
					b.damage = 9 * stats[0]
					shot_num = 0
				else:
					b.damage = 3 + stats[0] * 2
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.look_at(get_global_mouse_position())
				b.damage = 3 + stats[0] * 2
				get_tree().root.add_child(b)
			shot_num += 1
		1:
			for i in range(int(8 * stats[4])):
				global.shake += 2
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.look_at(get_global_mouse_position())
				b.maxdistance = randi_range(30,40)
				b.damage = 5 + stats[0] * 2
				b.accuracy = 20
				b.speed *= randf_range(0.9,0.6) * 2
				get_tree().root.add_child(b)
		2:
			for i in range(int(1 + (stats[4] * 0.285714286))):
				global.shake += 2
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.maxdistance = 80
				b.accuracy = 10
				b.damage = 2 + stats[0] * 2
				b.look_at(get_global_mouse_position())
				get_tree().root.add_child(b)
		3:
			for i in range(1 + int(1 * stats[4])):
				global.shake += 4
				var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.speed = 1800
				b.dagger = true
				b.accuracy = 15
				b.damage = 15 + stats[0] * 2
				b.look_at(get_global_mouse_position())
				get_tree().root.add_child(b)
		4:
			for i in range(int(1 * (stats[4] * 2))):
				global.shake += specialshotcharge
				global.shake = clamp(global.shake, 0, 35)
				var b = preload("res://scenes/bullets/lasershot.tscn").instantiate()
				b.position = $arrow.global_position + $arrow.transform.x * $arrow.offset.x
				b.rotation_degrees += randi_range(-5,5)
				b.damage = specialshotcharge + stats[0] * 4
				b.look_at(get_global_mouse_position())
				get_tree().root.add_child(b)
				print(str(b.damage))


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
			global.playerdead = true

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


func _on_hitbox_body_entered(body):
	if not cur_targs.has(body):
		cur_targs.append(body)
	saw_timer = saw_spd

func saw(body):
	if body.has_method("damage"):
		body.damage(saw_dmg)
		spawn_hit_particles(body)

func spawn_hit_particles(body):
	var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
	b.global_position = body.global_position
	get_tree().root.add_child(b)

func _on_hitbox_body_exited(body):
	cur_targs.erase(body)
