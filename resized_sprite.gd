tool
extends Sprite
class_name ResizedSprite

export var SIZE = Vector2(711,800) setget set_SIZE

func _ready():
	resize()

func resize():
	var img = texture.get_data()
	if img == null:
		return
	img.resize(SIZE.x, SIZE.y)
	texture = ImageTexture.new()
	texture.create_from_image(img)

func set_SIZE(size):
	SIZE = size
	resize()

func _on_resized_sprite_texture_changed():
	resize()
