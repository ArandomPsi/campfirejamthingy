extends Node2D

var portalopened : bool = false

var bugs : Array = [preload("res://scenes/bugs/basicbug.tscn"),preload("res://scenes/bugs/combuster.tscn"),preload("res://scenes/bugs/bee.tscn"),preload("res://scenes/bugs/millipede.tscn")]

var getsit : bool = false

func _ready():
	tutorialthing()
	$portal1.modulate = Color(1,1,1,0)

func tutorialthing():
	
	
	while not getsit:
		await get_tree().process_frame 
	print("yes")
	var b = preload("res://scenes/bugs/basicbug.tscn").instantiate()
	add_child(b)
	b.position.x = 1352/2
	b.position.y = 648/2
	$portal1.modulate = Color(1,1,1,0)
	var timer = get_tree().create_timer(0.4)
	await timer.timeout
	var tween = create_tween()
	tween.tween_property($Label,"modulate",Color(1,1,1,0),1.5)
	$buffer.queue_free()

func _process(delta):
	if not portalopened and not $enemychecker.has_overlapping_bodies() and getsit:
		portalopened = true
		openportal()
	
	if $enemychecker.has_overlapping_bodies():
		portalopened = false
		$portal1.modulate = Color(1,1,1,0)
		$TileMap.modulate = lerp($TileMap.modulate,Color("ff7aad"),0.05)
	else:
		$TileMap.modulate = lerp($TileMap.modulate,Color("00a9ff"),0.05)
		
	
	$portal1/Area2D/CollisionShape2D.disabled = not portalopened
	
	if Input.is_action_just_released("shoot"):
		getsit = true
	


func openportal():
	var tween = create_tween()
	tween.tween_property($portal1,"modulate",Color(1,1,1,1),0.5)
	$upgradeportal.appear()
	


func _on_area_2d_body_entered(body):
	$player.transition()
	$player.hp = $player.maxhp
	var timer = get_tree().create_timer(0.3)
	$upgradeportal.visible = false
	$player.position = Vector2(1344/2,806/2)
	global.room = clampi(global.room,0,5)
	await timer.timeout
	for i in range(randi_range(1,2) + global.room):
		var b = bugs.pick_random().instantiate()
		b.position.x = randi_range(100,1320)
		b.position.y = randi_range(20,648)
		add_child(b)
		
		
	global.room += randi_range(0,1.2) #20 percent chance of scaling up

func upgradething(trick): #for signal
	$player.showupgrades()



"""
var enemies = [exported]
var size_array =  [1, 2, 3, 3]
var max_size = 1
var cur_size = max_size

for i in range(len(
	
))

"""


