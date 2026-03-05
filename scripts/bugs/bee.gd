extends CharacterBody2D

var speed : int = 150
var attackchargeup : int = 120
var shaking : int = 0
var hp : int = 54 + global.room * 2
var spawnedin : bool = false

var t : float = 0


func _ready():
	var tween = create_tween()
	
	$sprite.scale = Vector2.ZERO
	rotation_degrees = randi_range(0,360)
	tween.tween_property($sprite,"scale",Vector2(1,1),0.5).set_delay(0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	spawnedin = true
	

func _physics_process(delta):
	t += 1
	if not $attackplayer.is_playing() and spawnedin:
		var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.1)
		
		velocity += speed * delta * transform.x * 10
		velocity *= 0.9
		attackchargeup -= 1
		if attackchargeup < 1:
			$attackplayer.speed_scale = randf_range(0.8,1.2)
			$attackplayer.play("speedthing")
			attackchargeup = randi_range(180,280)
		attackchargeup -= 1
	elif not spawnedin:
		velocity = Vector2.ZERO
	
	
	shaking -= 1
	$sprite.offset = Vector2.ZERO
	if shaking > 1:
		$sprite.offset += Vector2(randi_range(-5,5),randi_range(-5,5))
	
	$sprite/wing1.rotation_degrees = sin(float(t/5)) * 15
	$sprite/wing2.rotation_degrees = -sin(float(t/5)) * 15
	
	move_and_slide()
	

func charge():
	shaking = 30
	velocity *= 0.7

func rush():
	velocity = transform.x * randi_range(800,1000)

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

func chaindash():
	velocity *= 0.5
	var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
	var tween = create_tween()
	for i in range(30):
		v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.15)
		var timer = get_tree().create_timer(1/120)
		await timer.timeout
	
	velocity = transform.x * (1500 + (global.room * 25))

func burn(amount):
	for i in range(5):
		var c = preload("res://scenes/vfx/flaming.tscn").instantiate()
		add_child(c)
		c.emitting = true
		c.global_position = global_position
		damage(amount)
		await get_tree().create_timer(1.0).timeout

func _on_area_2d_2_body_entered(body):
	print("yes")
	$bouncelook.look_at(body.position)
	velocity += -$bouncelook.transform.x * randi_range(400,800)
