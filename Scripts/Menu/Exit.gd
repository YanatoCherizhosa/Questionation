extends Button

func _on_Exit_pressed():
	get_tree().quit()

func _on_Exit_mouse_entered():
	GlobalSounds.buttonEnter()
