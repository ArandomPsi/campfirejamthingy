extends Node2D

@export var damage : int = 20


func _ready():
	var b = preload("res://scenes/sounds/shoot.tscn").instantiate()
	get_tree().root.add_child(b)
	spawnstart()
	var timer = get_tree().create_timer(0.08)
	
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.3)
	await timer.timeout
	$Area2D/CollisionShape2D.disabled = false
	await tween.finished
	queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
		var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = body.position
	

func spawnstart():
	var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
	get_tree().root.add_child(b)
	b.position = position


