extends Node2D

var attacks : Array = ["flashfire", "enemy", "fireball"]
var hp : int = 7500


func _ready():
	randomize()


func _process(delta):
	if not $attackplayer.is_playing():
		$attackplayer.play(attacks.pick_random())
	if global.playerdead:
		queue_free()

func spawnflashfire():
	var b = preload("res://scenes/bugs/f_lash_fire_attack.tscn").instantiate()
	get_tree().root.add_child(b)
	b.position = Vector2.ZERO

func spawnfireball():
	for i in range(randi_range(2, 4)):
		var b = preload("res://scenes/bugs/fireball.tscn").instantiate()
		get_tree().root.add_child(b)
		b.position = $Marker2D.position
		b.position.x += randi_range(-500,500)
		b.look_at(global.playerpos)
		b.rotation_degrees += randi_range(-64, 64)

func spawnrandomenemy():
	for i in range(randi_range(1, 3)):
		var bugs : Array = [preload("res://scenes/bugs/basicbug.tscn"),preload("res://scenes/bugs/combuster.tscn"),preload("res://scenes/bugs/bee.tscn"),preload("res://scenes/bugs/millipede.tscn")]
		var b = bugs.pick_random().instantiate()
		b.position.x = randi_range(100,1320)
		b.position.y = randi_range(20,648)
		get_tree().root.add_child(b)

func damage(amount):
	hp -= amount
	if hp < 0:
		var b = preload("res://scenes/vfx/hitparticle.tscn").instantiate()
		get_tree().root.add_child(b)
		b.modulate = Color("#ff0095")
		b.scale *= 2
		queue_free()
