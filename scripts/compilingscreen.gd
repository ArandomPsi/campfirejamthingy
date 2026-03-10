extends Control

var amountcompiled : float = 0

func _ready() -> void:
	var timer = get_tree().create_timer(8)
	await timer.timeout
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")

func _process(delta: float) -> void:
	amountcompiled += 0.0335
	$Label.text = "<Compiling Game"
	for i in range(floor(amountcompiled)):
		$Label.text = $Label.text + " -"
	$Label.text = $Label.text + ">"
	
	
	
