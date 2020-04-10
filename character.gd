extends Node2D

export(String) var CHARACTER = "bear" setget set_character

onready var rng = RandomNumberGenerator.new()

func select_new_thought():
	var thoughts = Global.thoughts[CHARACTER]
	var i = rng.randi_range(0, len(thoughts)-1)
	var thought = thoughts[i]
	var texture = load("res://assets/graphics/stamps/%s.png" % thought)
	$thought_bubble/thought.texture = texture

func _ready():
	rng.randomize()
	_on_thought_hide_timer_timeout()

func set_character(character):
	CHARACTER = character
	var texture = load("res://assets/graphics/characters/%s.png" % CHARACTER)
	$sprite.texture = texture
	$sprite.resize()

func _on_thought_show_timer_timeout():
	$thought_bubble.show()
	$thought_hide_timer.start()

func _on_thought_hide_timer_timeout():
	$thought_bubble.hide()
	select_new_thought()
	var timeout = rand_range(3,30)
	$thought_show_timer.start(timeout)
