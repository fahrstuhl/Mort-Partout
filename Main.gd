extends Node2D

export(String) var CURRENT_CHARACTER = "beatle"
export(String) var CURRENT_STAMP = "cat" setget set_stamp

var stamp_scene = preload("res://stamp.tscn")
var button_scene = preload("res://named_button.tscn")
onready var mouse_stamp = stamp_scene.instance()

func _ready():
	mouse_stamp.STAMP = CURRENT_STAMP
	mouse_stamp.hide()
	add_child(mouse_stamp)
	populate_sticker_grid()

func _input(event):
	if event.is_action_type():
		if event.is_action("stamp_rotate_cw"):
			mouse_stamp.rotate(deg2rad(10))
		elif event.is_action("stamp_rotate_ccw"):
			mouse_stamp.rotate(deg2rad(-10))

func _process(delta):
	mouse_stamp.position = get_viewport().get_mouse_position()

func _on_canvas_stamp(pos):
	remove_child(mouse_stamp)
	var target = $Foreground/canvas/Viewport/stamps
	var stamp = mouse_stamp
	stamp.position = pos
	target.add_child(stamp)
	stamp.owner = target
	mouse_stamp = stamp_scene.instance()
	mouse_stamp.STAMP = CURRENT_STAMP
	add_child(mouse_stamp)

func give():
	var character = CURRENT_CHARACTER
	var evaluation = evaluate_paradise()
	var result = call("check_%s" % character, evaluation)
	print(result)
	change_canvas(0)

func check_bear(evaluation):

	var is_correct_env = evaluation["num"] == 2
	if not is_correct_env:
		return false
	var animals_on_ground = []
	for stamp in evaluation["areas"]["ground"]:
		if stamp in Global.animals:
			animals_on_ground.append(stamp)
	var has_enough_animals_on_ground = len(animals_on_ground) >= 5
	return has_enough_animals_on_ground

func check_beatle(evaluation):
	if not "sky" in evaluation["areas"]:
		return false
	var lucy = 0
	var diamonds = 0
	for stamp in evaluation["areas"]["sky"]:
		if stamp == "lucy":
			lucy += 1
		if stamp == "diamond":
			diamonds += 1
	return lucy == 1 and diamonds >= 2

func evaluate_paradise():
	return $Foreground/canvas/Viewport/background/paradise.evaluate()

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

func _on_Give_pressed():
	give()

func _on_canvas_mouse_entered():
	mouse_stamp.show()

func _on_canvas_mouse_exited():
	mouse_stamp.hide()

func set_stamp(stamp):
	print(stamp)
	CURRENT_STAMP = stamp
	mouse_stamp.STAMP = CURRENT_STAMP

func populate_sticker_grid():
	for stamp in Global.all_stamps:
		var button = button_scene.instance()
		var texture = load("res://assets/graphics/stamps/%s.png" % stamp)
		button.texture_normal = texture
		button.name = stamp
		$UI/pallet.add_child(button)
		button.connect("pressed_name", self, "set_stamp")
