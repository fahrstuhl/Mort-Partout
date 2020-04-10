tool
extends Node2D

export var CURRENT = 0 setget set_paradise

func _ready():
	set_paradise(CURRENT)

func set_paradise(num):
	CURRENT = num
	for each in get_children():
		var is_active = int(each.name) == CURRENT
		each.visible = is_active
		each.set_process(is_active)

func evaluate():
	var node = get_node(str(CURRENT))
	var evaluation = {"num": CURRENT, "areas": {}}
	for area in node.get_children():
		if area is Area2D:
			evaluation["areas"][area.name] = []
			for stamp in area.get_overlapping_areas():
				if stamp is Stamp:
					evaluation["areas"][area.name].append(stamp.STAMP)
	return evaluation
