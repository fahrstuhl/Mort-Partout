extends Node

onready var rng = RandomNumberGenerator.new()

var all_stamps = ["castle", "cat", "cow", "diamond", "game", "lucy", "monkey", "pig", "poodle", "rainbow", "woman"]

var animals = ["cat", "cow", "lucy", "monkey", "pig", "poodle"]

var thoughts = {
	"bear": animals + ["tree"],
	"animal_lover": animals,
	"beatle": ["lucy", "diamond", "rainbow", "sky"],
	"lesbian": ["woman", "rainbow"],
	"terrorist": ["woman", "beach"],
	"buddhist": ["nothing"],
	"jesus": ["earth"],
	"hedge_fond_manager": ["beach", "diamond"]
}

var all_characters = thoughts.keys()

func _ready():
	rng.randomize()
