extends Control

func _on_download_hide_timer_timeout():
	hide()

func inform(path):
	var text = path
	$Label.text = text
	show()
	$download_hide_timer.start()
