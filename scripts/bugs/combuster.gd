extends CharacterBody2D

var speed : int = 100 + global.trueroom * randi_range(4,8)
var attackchargeup : int = 120
var shaking : int = 0
var hp : int = 72 + global.trueroom * randi_range(2,4)
var spawnedin : bool = false

signal killed

func _ready():
	var tween = create_tween()
	
	$sprite.scale = Vector2.ZERO
	rotation_degrees = randi_range(0,360)
	tween.tween_property($sprite,"scale",Vector2(1,1),0.5).set_delay(0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	spawnedin = true
	

func _physics_process(delta):
	if not $attackplayer.is_playing() and spawnedin:
		var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.1)
		
		velocity += speed * delta * transform.x * 10
		
		attackchargeup -= 1
		if attackchargeup < 1 and not global.playerdead:
			$attackplayer.speed_scale = randf_range(0.8,1.2)
			$attackplayer.play("diddle")
			attackchargeup = randi_range(180,280)
		attackchargeup -= 1
	elif not spawnedin:
		velocity = Vector2.ZERO
	
	
	shaking -= 1
	$sprite.offset = Vector2.ZERO
	if shaking > 1:
		$sprite.offset += Vector2(randi_range(-5,5),randi_range(-5,5))
	
	velocity *= 0.9
	
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
		killed.emit()
		queue_free()

func burn(amount):
	for i in range(5):
		var c = preload("res://scenes/vfx/flaming.tscn").instantiate()
		add_child(c)
		c.emitting = true
		c.global_position = global_position
		damage(amount)
		await get_tree().create_timer(1.0).timeout

func bounce():
	rotation_degrees += randi_range(-15,15)
	velocity = -transform.x * velocity.length()

func _on_area_2d_body_entered(body):
	
	bounce()

func goonstuff():
	for i in range(15):
		var b = preload("res://scenes/bugs/slime.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = position
		b.rotation = rotation
		b.rotation_degrees += randi_range(40,-40)
		b.speed *= randf_range(0.8,1.2)

func _on_area_2d_2_body_entered(body):
	$bouncelook.look_at(body.position)
	velocity += -$bouncelook.transform.x * randi_range(400,800)
