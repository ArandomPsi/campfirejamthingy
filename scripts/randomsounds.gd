extends AudioStreamPlayer2D
@export var min : float = 0.5
@export var max : float = 1.5

func _ready():
	pitch_scale *= randf_range(min,max)
	playing = true
	await finished
	queue_free()
