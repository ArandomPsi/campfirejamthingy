extends CharacterBody2D

var speed : int = 80 + global.room * 2
var attackchargeup : int = 120
var shaking : int = 0
var hp : int = 64 + global.room * 2
var spawnedin : bool = false


func _ready():
	var tween = create_tween()
	
	$sprite.scale = Vector2.ZERO
	rotation_degrees = randi_range(0,360)
	tween.tween_property($sprite,"scale",Vector2(1,1),0.5).set_delay(0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	spawnedin = true
	

func _physics_process(delta):
	if not $attackplayer.is_playing() and spawnedin:
		var v = (global.playerpos + - position).angle()
		rotation = lerp_angle(rotation,v,0.05)
		
		velocity += speed * delta * transform.x * 10
		
		
		if attackchargeup < 1:
			$attackplayer.play("goon")
			attackchargeup = randi_range(150,180)
		
		attackchargeup -= 1
		
	elif not spawnedin:
		velocity = Vector2.ZERO
	
	velocity *= 0.9
	shaking -= 1
	$sprite.offset = Vector2.ZERO
	if shaking > 1:
		$sprite.offset += Vector2(randi_range(-5,5),randi_range(-5,5))
	
	
	
	move_and_slide()
	

func charge():
	shaking = 30
	velocity *= 0.7

func rush():
	velocity = transform.x * randi_range(2000,2400)

func damage(amount):
	hp -= amount
	if hp < 0:
		var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
		get_tree().root.add_child(b)
		b.modulate = $sprite.modulate
		b.position = position
		b.scale *= 2
		queue_free()

func bounce():
	rotation_degrees += randi_range(-15,15)
	velocity = -transform.x * velocity.length()

func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
	bounce()

func bombthing():
	for i in range(10):
		for e in range(3):
			var b = preload("res://scenes/vfx/aoe.tscn").instantiate()
			get_tree().root.add_child(b)
			b.rotation = rotation
			b.rotation_degrees += -40 + (40 * e)
			b.position = position + b.transform.x * (75 * i)
			b.rotation = 0
		var timer = get_tree().create_timer(0.05)
		await timer.timeout


func _on_area_2d_2_body_entered(body):
	print("yes")
	$bouncelook.look_at(body.position)
	velocity += -$bouncelook.transform.x * randi_range(400,800)
