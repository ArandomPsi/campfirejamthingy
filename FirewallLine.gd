extends Node2D

@export var maxdistance : int = 360
@export var speed : int = 900

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	maxdistance -= 1
	if maxdistance < 0:
		queue_free()


func _on_hitbox_body_entered(body):
	body.damage(1)
