extends Node2D
@export var maxdistance : int = 180
@export var speed : int = 800
@export var accuracy : int = 5
@export var damage : int = 2

func _ready():
	rotation_degrees += randf_range(-accuracy,accuracy)

func _process(delta):
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



