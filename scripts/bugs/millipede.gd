extends CharacterBody2D

var speed : int = 250 + global.trueroom * randi_range(2,5)
var attackchargeup : int = 120
var shaking : int = 0
var hp : int = 78 + global.trueroom * randi_range(4,7)
var spawnedin : bool = false

var t : float = 0

var prevpos : Array
var rotathing : float = 0


func _ready():
	var tween = create_tween()
	for i in range(360):
		prevpos.push_back(position)
	self.scale = Vector2.ZERO
	rotation_degrees = randi_range(0,360)
	tween.tween_property(self,"scale",Vector2(1,1),0.5).set_delay(0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	spawnedin = true
	

func _physics_process(delta):
	prevpos.push_front(position)
	prevpos.erase(360)
	t += 1
	if not $attackplayer.is_playing() and spawnedin:
		var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.05)
		if attackchargeup < 1 and not global.playerdead:
			$attackplayer.speed_scale = randf_range(0.8,1.2)
			$attackplayer.play("spam")
			rotathing = randi_range(-300,300)
			attackchargeup = randi_range(180,280)
		
		
		attackchargeup -= 1
		attackchargeup -= 1
	elif not spawnedin:
		velocity = Vector2.ZERO
	elif $attackplayer.is_playing():
		rotation_degrees += rotathing * delta
	velocity += speed * delta * transform.x * 10
	velocity *= 0.9
	shaking -= 1
	$sprite.offset = Vector2.ZERO
	if shaking > 1:
		$sprite.offset += Vector2(randi_range(-5,5),randi_range(-5,5))
	
	if global.playerdead:
		queue_free()
	
	
	move_and_slide()
	

func charge():
	shaking = 30
	velocity *= 0.7

func burn(amount):
	for i in range(5):
		var c = preload("res://scenes/vfx/flaming.tscn").instantiate()
		add_child(c)
		c.emitting = true
		c.global_position = global_position
		damage(amount)
		await get_tree().create_timer(1.0).timeout

func rush():
	velocity = transform.x * randi_range(800,1000)

func shoot():
	var joints : Array = [$joint1,$joint2,$joint3,$joint4,$joint5,$joint6,$joint7,$joint8]
	for d in range(3):
		for i in range(8):
			for e in range(2):
				var b = preload("res://scenes/bullets/enemybullet.tscn").instantiate()
				get_tree().root.add_child(b)
				b.position = joints[i].global_position
				b.rotation_degrees = rotation_degrees - 90
				if e == 1:
					b.rotation_degrees += 180
			var timer = get_tree().create_timer(0.05)
			await timer.timeout
			

func damage(amount):
	hp -= amount
	if hp < 0:
		var joints : Array = [self,$joint1,$joint2,$joint3,$joint4,$joint5,$joint6,$joint7,$joint8]
		for i in range(9):
			var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
			get_tree().root.add_child(b)
			b.modulate = $sprite.modulate
			b.position = joints[i].global_position
			b.scale *= 2
		queue_free()

func bounce():
	rotation_degrees += randi_range(-15,15)
	velocity = -transform.x * velocity.length()

func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
	bounce()

func chaindash():
	velocity *= 0.5
	var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
	var tween = create_tween()
	for i in range(30):
		v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.15)
		await get_tree().process_frame
	
	velocity = transform.x * 1500


func _on_area_2d_2_body_entered(body):
	print("yes")
	$bouncelook.look_at(body.position)
	velocity += -$bouncelook.transform.x * randi_range(400,800)
