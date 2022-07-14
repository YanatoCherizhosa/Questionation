extends Button

func _on_Play_pressed():
	if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
		print ("An unexpected error occured when trying to switch to the Readme scene")


func _on_Play_mouse_entered():
	SoundManager.buttonEnter()
