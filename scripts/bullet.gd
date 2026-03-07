extends Node2D
@export var maxdistance : int = 180
@export var speed : int = 800
@export var accuracy : int = 5
@export var damage : int = 2
@export var dagger : bool = false
var back : bool = false
@export var flame : bool = false


func _ready():
	if not flame:
		var b = preload("res://scenes/sounds/shoot.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = position
	rotation_degrees += randf_range(-accuracy,accuracy)
	if dagger:
		$Sprite2D.texture = preload("res://assets/Dagger.svg")
		$Sprite2D.scale = Vector2(1, 1)

func _process(delta):
	if dagger:
		speed -= 5
		position += transform.x * speed * delta
		$Sprite2D.rotation += PI / 10
	else:
		position += transform.x * delta * speed
		maxdistance -= 1
		if maxdistance < 0:
			
			queue_free()
		


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
	spawnhit()
	queue_free()

func spawnhit():
	var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
	get_tree().root.add_child(b)
	b.position = position
