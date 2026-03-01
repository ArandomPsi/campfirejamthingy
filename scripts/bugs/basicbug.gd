extends CharacterBody2D

var speed : int = 270
var attackchargeup : int = 120
var shaking : int = 0
var hp : int = 18
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
		var v = ((global.playerpos + Vector2(randi_range(-80,80),randi_range(-80,80))) - position).angle()
		rotation = lerp_angle(rotation,v,0.1)
		
		velocity += speed * delta * transform.x * 10
		
		attackchargeup -= 1
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


func _on_area_2d_2_body_entered(body):
	print("yes")
	$bouncelook.look_at(body.position)
	velocity += -$bouncelook.transform.x * randi_range(400,800)
