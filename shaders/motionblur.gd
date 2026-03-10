extends ColorRect

func _ready():
	visible = false

func _process(delta):
	accumulation_motion_blur_shader(material)


## Godot Accumulation Motion Blur
## By Lamb; MIT license
##
## Use in conjunction with the accumulation_motion_blur shader material.


func accumulation_motion_blur_shader(material: ShaderMaterial, viewport: Viewport = get_tree().root.get_viewport(), post_frame_draw: bool = true) -> void:
	var image: Image = viewport.get_texture().get_image()
	var texture: ImageTexture = ImageTexture.create_from_image(image)

	if post_frame_draw:
		await RenderingServer.frame_post_draw

	material.set_shader_parameter("framebuffer", texture)
