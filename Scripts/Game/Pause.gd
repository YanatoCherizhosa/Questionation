extends Control

var pause_state

func _input(event):
	if (event.is_action_pressed("ui_cancel") || get_tree().current_scene.pause_mode ):
		
		pause_state = not get_tree().paused
		if pause_state:
			GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundPausedVolume
			VisibilityStatus()
		else:
			GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundVolume
			pause_state = not get_tree().paused
			VisibilityStatus()
			
func VisibilityStatus():
	get_tree().paused = pause_state
	visible = pause_state
	for node in get_tree().get_nodes_in_group("Pause"):
		node.visible = pause_state
