tool
extends Node2D
class_name Stamp

export(String) var STAMP = "castle" setget set_stamp

func _ready():
	set_stamp(STAMP)

func set_stamp(stamp):
	STAMP = stamp
	var path = "res://assets/graphics/stamps/%s.png" % STAMP
	var texture = load(path)
	var size = texture.get_size()/2
	$resized_sprite.texture = texture
	$resized_sprite.SIZE = size
	$shape.shape.extents = size/2
