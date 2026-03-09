extends CanvasLayer

@onready var msg: Label = $mSG
var lines : Array = ["/", "_", "\\", "|"]
var cur_line : int = 0
var frame_num : int = 7
var frames : int = frame_num
@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	await get_tree().create_timer(3.5).timeout
	queue_free()

func _process(delta: float) -> void:
	frames -= 1
	if frames <= 0:
		cur_line = cur_line + 1 if cur_line + 1 < 4 else 0
		msg.text = lines[cur_line] + "Saving Game"
		frames = frame_num
	sprite.rotation += delta * TAU
