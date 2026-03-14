extends Node2D
@export var maxdistance : int = 180
@export var speed : int = 800
@export var accuracy : int = 5
@export var damage : int = 2
@export var dagger : bool = false
@export var homing : bool = false
@export var curveballspawner : bool = false
@export var curveball : bool = false
var back : bool = false
@export var flame : bool = false

signal target_hit(dmg)

func _ready():
	if not flame:
		var b = preload("res://scenes/sounds/shoot.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = position
	rotation_degrees += randf_range(-accuracy,accuracy)
	if dagger:
		$Sprite2D.texture = preload("res://assets/Dagger.svg")
		$Sprite2D.scale = Vector2(1, 1)
		maxdistance = 99999
		
	if flame:
		scale = Vector2(0.5, 0.5)
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(2.5,2.5), 0.5)
	
	if curveballspawner: #for modulatitry
		maxdistance = 30
	

func _process(delta):
	if dagger:
		speed -= 5
		position += transform.x * speed * delta
		$Sprite2D.rotation += PI / 10
		maxdistance -= 1
	else:
		position += transform.x * delta * speed
		maxdistance -= 1
	
	if maxdistance < 0:
			if curveballspawner:
				curvyball()
			queue_free()
	
	if curveball:
		rotation_degrees += 300 * delta
	
	


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		if flame and body.has_method("burn") and global.ability:
			body.burn(damage)
		else:
			body.damage(damage)
		target_hit.emit(damage)
		if not body.name == "player":
			createdamagenumber(damage,body)
			
	if curveballspawner:
		curvyball()
	spawnhit()
	queue_free()

func spawnhit():
	var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
	get_tree().root.add_child(b)
	b.position = position
	if global.explosion:
		spawnexplosion()

func spawnexplosion():
	if $Area2D.get_collision_mask_value(3): #only if its a player bullet
		var b = preload("res://scenes/vfx/playeraoe.tscn").instantiate()
		get_tree().root.add_child(b)
		b.dmg = global.explodedmg
		b.position = position
	

func curvyball():
	for i in range(8):
		var b = preload("res://scenes/bullets/bullet.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = position
		b.rotation_degrees = 45 * i
		b.maxdistance = 50
		b.damage = damage/2
		b.position += 15 * b.transform.x
		b.curveball = true

func createdamagenumber(amount,body : Node2D):
	var b = preload("res://scenes/vfx/damagelabel.tscn").instantiate()
	b.position = body.global_position
	b.damage = amount
	get_tree().root.add_child(b)
	


func _on_enemychecker_body_entered(body: Node2D) -> void:
	if homing:
		look_at(body.position)
		maxdistance *= 200
	
