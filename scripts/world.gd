extends Node2D

var portalopened : bool = false

var bugs : Array = [preload("res://scenes/bugs/basicbug.tscn"),preload("res://scenes/bugs/combuster.tscn"),preload("res://scenes/bugs/bee.tscn"),preload("res://scenes/bugs/millipede.tscn"), preload("res://scenes/bugs/scorpion.tscn"), preload("res://scenes/bugs/spooder.tscn")]
var sizes : Array = [1,2,3,7,6,8]
var max_size : int = randi_range(1,2)
var cur_size : int = max_size

var getsit : bool = false
var triggered : bool = false

func _ready():
	$portal1.modulate = Color(1,1,1,0)
	$buffer.queue_free()

func _process(delta):
	if not portalopened and not $enemychecker.has_overlapping_bodies() and not triggered:
		portal_delay()
		triggered = true
	
	if $enemychecker.has_overlapping_bodies():
		portalopened = false
		$portal1.modulate = Color(1,1,1,0)
		$TileMap.modulate = lerp($TileMap.modulate,Color("ff7aad"),0.05)
	else:
		$TileMap.modulate = lerp($TileMap.modulate,Color("00a9ff"),0.05)
		
	
	$portal1/Area2D/CollisionShape2D.disabled = not portalopened
	$portal1/Area2D/CollisionShape2D2.disabled = $portal1/Area2D/CollisionShape2D.disabled
	
	
	

func portal_delay():
	if global.trueroom > 0:
		max_size += randi_range(1, 2)
	openportal()
	await get_tree().create_timer(1.5).timeout
	portalopened = true
	print("hi")

func openportal():
	var tween = create_tween()
	tween.tween_property($portal1,"modulate",Color(1,1,1,1),0.5)
	if global.trueroom != 0:
		$upgradeportal.appear()
	


func _on_area_2d_body_entered(body):
	triggered = false
	if global.trueroom > 0:
		global.totalrooms += 1
	$Label.visible = false
	$player.transition()
	$player.hp = $player.maxhp
	var timer = get_tree().create_timer(0.3)
	$upgradeportal.visible = false
	$player.position = Vector2(1344/2,806/2)
	global.room = clampi(global.room,1,10)
	await timer.timeout
	cur_size = max_size
	if global.trueroom == 16:
		var b = preload("res://scenes/thefirewall.tscn").instantiate()
		add_child(b)
	else:
		while cur_size > 0:
			var r = randi_range(0, len(bugs) - 1)
			while sizes[r] > cur_size:
				r = randi_range(0, len(bugs) - 1)
			var b = bugs[r].instantiate()
			cur_size -= sizes[r]
			b.position.x = randi_range(100,1320)
			b.position.y = randi_range(20,648)
			add_child(b)
			
			var enhancementchance : int = 25 - global.trueroom
			enhancementchance = clamp(enhancementchance,1,25)
			
			if randi_range(0,enhancementchance) == 0:
				var e = preload("res://scenes/bugs/enemyenhancements.tscn").instantiate()
				b.add_child(e)
			
			
			
		
	
	$player.iframes = $player.maxiframes
	
	global.save(true)
	global.trueroom += 1
	global.room += randi_range(0,1.5) #5- percent chance of scaling up

func upgradething(trick): #for signal
	$player.showupgrades()
