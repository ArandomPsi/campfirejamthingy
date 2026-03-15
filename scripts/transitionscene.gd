extends Node2D

func _ready() -> void:
	await get_tree().process_frame #wait until previous scene is deleted
	get_tree().change_scene_to_file("res://scenes/testmap.tscn")
	
