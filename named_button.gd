extends TextureButton

signal pressed_name(name)

func _on_named_button_pressed():
	emit_signal("pressed_name", name)
