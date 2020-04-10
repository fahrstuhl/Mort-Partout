tool
extends Sprite

export var SIZE = Vector2(711,800) setget set_SIZE

func _ready():
	resize()
	
func resize():
	var img = texture.get_data()
	img.resize(SIZE.x, SIZE.y)
	texture = ImageTexture.new()
	texture.create_from_image(img)

func set_SIZE(size):
	SIZE = size
	resize()
