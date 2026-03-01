extends Control
var t : float
var currentweaponthingy : int = 0
var currentweaponthingytext : Array = ["Pea Shooter: "]


func _process(delta):
	$monitor/PointLight2D.energy = randf_range(0.45,0.5)
	$Lamp/PointLight2D.energy = randf_range(0.1,0.14)
	currentweaponthingy = clampi(currentweaponthingy,0,2)
	t += delta
	if not $Ps5/Button.is_hovered():
		$Ps5/Button/PointLight2D.texture_scale = (0.5 * sin(t * 5) + 0.5)/2
	else:
		$Ps5/Button/PointLight2D.texture_scale = 0.69
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/testmap.tscn")


func _on_up_pressed():
	currentweaponthingy += 1


func _on_down_pressed():
	currentweaponthingy -= 1


