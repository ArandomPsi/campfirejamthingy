extends Sprite2D
func _process(delta):
	rotation_degrees -= delta * 200
	$GPUParticles2D.global_rotation = 0
	$GPUParticles2D.emitting = visible
	$portalchecker/CollisionShape2D.disabled = not visible
	

func appear():
	visible = true
	var tween = create_tween()
	scale = Vector2.ZERO
	tween.tween_property(self,"scale",Vector2(1,1),0.3)


func _on_portalchecker_body_entered(body):
	var timer = get_tree().create_timer(1)
	await timer.timeout
	visible = false
