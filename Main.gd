extends Node2D

var stamp_scene = preload("res://stamp.tscn")

func _on_canvas_stamp(pos):
	var stamp = stamp_scene.instance()
	stamp.STAMP = "rainbow"
	stamp.position = pos
	$Foreground/canvas/Viewport/stamps.add_child(stamp)
	print($Foreground/canvas/Viewport/background/paradise.evaluate())

func change_canvas(num):
	$Foreground/canvas/Viewport/background/paradise.CURRENT = num
	for each in $Foreground/canvas/Viewport/stamps.get_children():
		each.queue_free()

func _on_0_pressed():
	change_canvas(0)

func _on_1_pressed():
	change_canvas(1)

func _on_2_pressed():
	change_canvas(2)

func _on_3_pressed():
	change_canvas(3)
