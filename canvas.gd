tool
extends TextureRect

signal stamp

func _ready():
	$Viewport.size = get_rect().size

func _gui_input(event):
	if Engine.editor_hint:
		return
	if event.is_action_type() and event.is_action("click") and event.is_pressed():
		print("stamping!")
		emit_signal("stamp", get_local_mouse_position())
