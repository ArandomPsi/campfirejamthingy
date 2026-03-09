extends Node2D

var boulettype : int = randi_range(0,2)

var nextguy : int = 0

var targetthingies : Array = [] #you can add more stuff if you want

var nextshottime : float = 0



func _process(delta: float) -> void:
	
	targetthingies = [$spinthingy/offset1.global_position,$spinthingy/offset2.global_position]
	
	$spinthingy.rotation_degrees += 300 * delta
	
	nextshottime += 1
	
	if nextshottime > 90 and not global.playerdead:
		spawnshot()
		nextshottime = 0
	
	


func spawnshot():
	match boulettype:
		0:
			var b = preload("res://scenes/bullets/enemybullet.tscn").instantiate()
			get_tree().root.add_child(b)
			b.position = targetthingies[nextguy]
			b.look_at(global.playerpos)
		1:
			for i in range(10):
				var b = preload("res://scenes/bugs/slime.tscn").instantiate()
				get_tree().root.add_child(b)
				b.position = targetthingies[nextguy]
				b.speed *= randi_range(0.5,1.5)
				b.look_at(global.playerpos)
				b.rotation_degrees += randi_range(-30,30)
		2:
			for i in range(10):
				for e in range(3):
					var b = preload("res://scenes/vfx/aoe.tscn").instantiate()
					get_tree().root.add_child(b)
					b.rotation = $spinthingy.rotation
					b.rotation_degrees += -120 + (120 * e)
					b.scale *= 0.75
					b.position = targetthingies[nextguy] + b.transform.x * (75 * i)
					b.rotation = 0
				var timer = get_tree().create_timer(0.05)
				await timer.timeout
	
	
	
	nextguy += 1
	if nextguy > 1:
		nextguy = 0
	
