extends Node2D
var speed : int = 1200
var frames : int = 40

func _process(delta):
	position += transform.x * speed * delta
	$Sprite2D.scale *= 0.97
	frames -= 1
	if frames < 0:
		queue_free()
	


func _on_area_2d_body_entered(body):
	body.damage(1)
