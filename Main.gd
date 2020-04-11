extends Node2D

export(String) var CURRENT_STAMP = "cat" setget set_stamp

var stamp_scene = preload("res://stamp.tscn")
var button_scene = preload("res://named_button.tscn")
var character_scene = preload("res://character.tscn")
onready var mouse_stamp = stamp_scene.instance()
var current_character
var current_level = 1
var level_finished = true
var current_score = 0
var scores = {}

func _ready():
	mouse_stamp.STAMP = CURRENT_STAMP
	mouse_stamp.hide()
	add_child(mouse_stamp)
	populate_sticker_grid()
	populate_queue()
	$first_start_screen.show()

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

func populate_queue():
	randomize()
	var characters = Array(Global.all_characters)
	characters.shuffle()
	var start = get_node("Background/Positions/10")
	for i in range(len(characters)):
		var instance = character_scene.instance()
		instance.CHARACTER = characters[i]
		if i == 0:
			current_character = instance
		var pos = get_node("Background/Positions/%d" % i)
		copy_pos(start, instance)
		instance.queue_position = i
		$Background/Characters.add_child(instance)
		move_pos(pos, instance)

func pop_queue():
	for character in $Background/Characters.get_children():
		character.queue_position -= 1
		character.queue_position = max(character.queue_position, -1)
		var pos = get_node("Background/Positions/%d" % character.queue_position)
		move_pos(pos, character)
		if character.queue_position == 0:
			current_character = character

func copy_pos(pos, instance):
	for prop in ["global_position", "scale", "z_index", "modulate"]:
		instance.set(prop, pos.get(prop))

func move_pos(pos, instance):
	var tween = instance.get_node("Tween")
	tween.remove_all()
	for prop in ["global_position", "scale", "modulate"]:
		var delay = rand_range(1,2)
		var duration = rand_range(0.5,1)
		tween.interpolate_property(
			instance,
			prop,
			instance.get(prop),
			pos.get(prop), 
			duration,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT,
			delay
			)
	instance.wiggle()
	instance.z_index = pos.z_index
	tween.start()

func give():
	if level_finished:
		return
	var character_type = current_character.CHARACTER
	var evaluation = evaluate_paradise()
	var score = min(call("check_%s" % character_type, evaluation), 5)
	current_character.set_score_thought(score)
	change_canvas(0)
	current_score += score
	pop_queue()
	test_level_end()

func test_level_end():
	var tmp_level_finished = true
	var characters = $Background/Characters.get_children()
	for each in characters:
		if each.queue_position != -1:
			tmp_level_finished = false
	level_finished = tmp_level_finished
	if level_finished:
		scores[current_level] = current_score
		var text = "You finished level {0}!\nYour score is {1}.\nGood Job!"
		$level_finished_screen/container/Label.text = text.format([current_level, current_score])
		$level_finished_screen.show()

func start_next_level():
	$level_finished_screen.hide()
	$level_finished_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current_level += 1
	current_score = 0
	var characters = $Background/Characters.get_children()
	for character in characters:
		character.get_node("free_timer").start()
	populate_queue()
	level_finished = false

func check_bear(evaluation):
	var score = 1
	var is_correct_env = evaluation["num"] == 2
	if is_correct_env:
		score += 1
	var animals = 0
	for area in evaluation["areas"]:
		for stamp in evaluation["areas"][area]:
			if stamp in Global.animals:
				animals += 1
	score += clamp(animals, 0, 3)
	return score

func check_beatle(evaluation):
	var score = 1
	var lucy = 0
	var diamonds = 0
	if "sky" in evaluation["areas"]:
		score += 1
		for stamp in evaluation["areas"]["sky"]:
			if stamp == "lucy":
				lucy += 1
			if stamp == "diamond":
				diamonds += 1
	if lucy >= 1:
		score += 1
	if diamonds >= 2:
		score += 2
	elif diamonds == 1:
		score += 1
	return score

func check_buddhist(evaluation):
	var score = 5
	if evaluation["num"] != 0:
		score -= 1
	for area in evaluation["areas"]:
		for thing in evaluation["areas"][area]:
			score -= 1
	return int(clamp(score, 1, 5))

func check_lesbian(evaluation):
	var score = 1
	var rainbow = 0
	var women = 0
	for area in evaluation["areas"]:
		for stamp in evaluation["areas"][area]:
			if stamp == "woman":
				women += 1
			if stamp == "rainbow":
				rainbow = 1
	women = int(clamp(women, 0, 4))
	score += women + rainbow
	return score

func check_terrorist(evaluation):
	var score = 1
	var women = 0
	if evaluation["num"] == 3:
		score += 1
	for area in evaluation["areas"]:
		for stamp in evaluation["areas"][area]:
			if stamp == "woman":
				women += 1
	women = int(clamp(women, 0, 3))
	score += women
	return score

func check_hedge_fond_manager(evaluation):
	var score = 1
	var diamonds = 0
	if evaluation["num"] == 1:
		score += 1
	for area in evaluation["areas"]:
		for stamp in evaluation["areas"][area]:
			if stamp == "diamond":
				diamonds += 1
	diamonds = int(clamp(diamonds, 0, 4))
	score += diamonds
	return score

func check_animal_lover(evaluation):
	var score = 1
	var animals = 0
	for area in evaluation["areas"]:
		for stamp in evaluation["areas"][area]:
			if stamp in Global.animals:
				animals += 1
	score += clamp(animals, 0, 4)
	return score

func check_jesus(evaluation):
	return 1

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


func _on_start_game_pressed():
	$first_start_screen.hide()
	$first_start_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	level_finished = false

func _on_Download_pressed():
	if OS.get_name() == "HTML5":
		$download_info.inform("Saving images is not supported in browsers, please download the native version.\nOr take a screenshot!")
		return
	var t = OS.get_datetime()
	var f = [t["year"], t["month"], t["day"], t["hour"], t["minute"], t["second"]]
	var image_name = "%04d-%02d-%02d_%02d-%02d-%02d.png" % f
	var readable_path = "%s/%s" % [OS.get_user_data_dir(), image_name]
	var to_print = "Current painting saved to:\n%s" % readable_path
	var save_path = "user://%s" % image_name
	var img = $Foreground/canvas/Viewport.get_texture().get_data()
	img.save_png(save_path)
	$download_info.inform(to_print)
