extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var i = [-1, 1].pick_random()
	$FlipAxis.scale.x = i
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished
	$FlipAxis/GPUParticles2D.emitting = true
	await get_tree().create_timer(0.5).timeout
	$FlipAxis/Hitbox/CollisionShape2D.disabled = false
	await $FlipAxis/GPUParticles2D.finished
	queue_free()







func _on_hitbox_body_entered(body):
	body.damage(2)


func _on_gpu_particles_2d_finished():
	queue_free()
