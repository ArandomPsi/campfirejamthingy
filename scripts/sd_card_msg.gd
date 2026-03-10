extends CanvasLayer

@onready var msg: Label = $mSG
var lines : Array = ["/", "_", "\\", "|"]
var cur_line : int = 0
var frame_num : int = 7
var frames : int = frame_num
@onready var sprite: Sprite2D = $sprite
var framethingy : float

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _process(delta: float) -> void:
	framethingy += delta
	frames -= 1
	if frames <= 0:
		cur_line = cur_line + 1 if cur_line + 1 < 4 else 0
		msg.text = "COMPILING DATA"
		frames = frame_num
	$Sdcard.scale.y = sin(framethingy*8) * 0.5
