extends ColorRect

func _ready():
	visible = true

func _process(delta):
	color.a = global.flash
