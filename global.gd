extends Node

var playerpos : Vector2
var flash : float = 0
var room : int = 0
var shake : float = 0
var playerweapon : int = 0
var trueroom : int = 0
var bestroom : int = 0
var playerdead : bool = false
var totalrooms : int = 50
var autosave_time : float = 5.0
var save_timer : float = autosave_time
var lifesteal : bool = false
var ability : bool = false

func _ready():
	safeload()

func _process(delta):
	if trueroom - 2 > bestroom:
		bestroom = trueroom - 2
	shake -= delta * 120
	shake = clampi(shake,0,35)
	flash = lerpf(flash,0.0,0.15)
	save_timer -= delta
	if save_timer <= 0.0:
		save(false)
		save_timer = autosave_time
		
func save(msg : bool):
	if msg:
		save_msg()
	SaveFile.save_game({
		"playerweapon": playerweapon,
		"bestroom": bestroom,
		"totalrooms": totalrooms,
	})

func save_msg():
	if get_tree().current_scene.name == "world":
		var c = CanvasLayer.new()
		var b = preload("res://scenes/sd_card_msg.tscn").instantiate()
		get_tree().root.add_child(b)

func safeload():
	var data = SaveFile.load_game()
	if data.has("playerweapon"):
		playerweapon = data.get("playerweapon", 0)
	if data.has("bestroom"):
		bestroom = data.get("bestroom", 0)
	if data.has("totalrooms"):
		totalrooms = data.get("totalrooms", 0)
