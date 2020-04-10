tool
extends Node2D
class_name Stamp

export(String, "castle", "cat", "cow", "diamond", "game", "lucy", "monkey", "pig", "poodle", "rainbow") var STAMP = "castle"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var path = "res://assets/graphics/stamps/%s.png" % STAMP
	print(path)
	var texture = load(path)
	var size = texture.get_size()
	$resized_sprite.SIZE = size
	$resized_sprite.texture = texture
	$shape.shape.extents = size/2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
