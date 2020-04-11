tool
extends Node2D

export(String) var CHARACTER = "Toter" setget set_character

var ready = false
var done = false
var queue_position

func select_new_thought():
	if done:
		return
	var thoughts = Global.thoughts[CHARACTER]
	var i = Global.rng.randi_range(0, len(thoughts)-1)
	var thought = thoughts[i]
	var texture = load("res://assets/graphics/stamps/%s.png" % thought)
	$thought_bubble/thought.set_texture(texture)

func set_score_thought(score):
	var texture = load("res://assets/graphics/scores/%d.png" % score)
	$thought_bubble/thought.set_texture(texture)
	_on_thought_show_timer_timeout()
	done = true

func _ready():
	_on_thought_hide_timer_timeout()
	ready = true
	set_character(CHARACTER)

func set_character(character):
	CHARACTER = character
	if not ready:
		return
	var path = "res://assets/graphics/characters/%s.png" % CHARACTER
	var texture = load(path)
	$sprite.set_texture(texture)

func _on_thought_show_timer_timeout():
	if done:
		return
	$thought_bubble.show()
	Global.rng.randomize()
	var i = Global.rng.randi_range(1,24)
	var sound = load("res://assets/sounds/r%s_Selection.wav" % i)
	$bla_player.stream = sound
	$bla_player.play()
	wiggle(0,0.4)
	$thought_hide_timer.start()

func _on_thought_hide_timer_timeout():
	$thought_bubble.hide()
	select_new_thought()
	var timeout = rand_range(3,30)
	$thought_show_timer.start(timeout)
	
func _on_free_timer_timeout():
	queue_free()

func wiggle(delay=null, duration=null):
	var tween = $wiggle_tween
	if delay == null:
		delay = rand_range(1,1.5)
	if duration == null:
		duration = rand_range(0.5,1)
	var direction = sign(rand_range(-1,1))
	tween.interpolate_property(
		self,
		"rotation",
		- direction * deg2rad(2),
		+ direction * deg2rad(2),
		duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		delay
	)
	tween.interpolate_property(
		self,
		"rotation",
		+ direction * deg2rad(2),
		0,
		duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		delay + duration
	)
	tween.start()
