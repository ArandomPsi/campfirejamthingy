extends Sprite2D
@export var thing : int = 1
@export var nextjoint : Node2D
func _process(delta):
	global_position = get_parent().prevpos[thing * 10]
	look_at(nextjoint.global_position)
