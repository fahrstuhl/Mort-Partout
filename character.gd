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
	done = true
	var texture = load("res://assets/graphics/scores/%d.png" % score)
	$thought_bubble/thought.set_texture(texture)
	_on_thought_show_timer_timeout()

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
	$thought_bubble.show()
	$thought_hide_timer.start()

func _on_thought_hide_timer_timeout():
	$thought_bubble.hide()
	select_new_thought()
	var timeout = rand_range(3,30)
	$thought_show_timer.start(timeout)
	
func _on_free_timer_timeout():
	queue_free()
