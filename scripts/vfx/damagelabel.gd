extends Node2D
var damage : int = 1

func _ready():
	if damage < 1:
		queue_free()
	position += Vector2(-50,-50)
	$bypass/Label.text = str(damage)
	$bypass/Label.position.x += randi_range(-400,400)
	$bypass/Label.position.y -= randi_range(-400,400)
	$bypass/Label.global_position = position
	var tween = create_tween()
	tween.tween_property($bypass/Label,"modulate",Color(1,1,1,0),0.5).set_delay(0.3)
	await tween.finished
	queue_free()
