extends Sprite

func _ready():
	if OS.get_name() == "HTML5":
		show()
	else:
		queue_free()

func _process(delta):
	position = get_viewport().get_mouse_position()
