extends Control

var amountcompiled : float = 0

func _ready() -> void:
	var timer = get_tree().create_timer(15)
	await timer.timeout
	if not global.tutorialed:
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
	

func _process(delta: float) -> void:
	amountcompiled += 0.0335
	print(str(amountcompiled))
	#compilething
	if amountcompiled > 60:
		if not global.tutorialed:
			get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
	
	$Label.text = "<Compiling Game"
	for i in range(floor(amountcompiled)):
		$Label.text = $Label.text + " -"
	$Label.text = $Label.text + ">"
	
	
	
