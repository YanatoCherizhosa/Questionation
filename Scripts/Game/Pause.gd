extends Control

var pause_state

func _input(event):
	if (event.is_action_pressed("ui_cancel") || get_tree().current_scene.pause_mode ):
		pause_state = not get_tree().paused
		#if  Player.currentHealth == 0:
		#	Player.currentHealth = 3
		if pause_state:
			VisibilityStatus()
		else:
			pause_state = not get_tree().paused
			VisibilityStatus()
			
func VisibilityStatus():
	get_tree().paused = pause_state
	visible = pause_state
	for node in get_tree().get_nodes_in_group("Pause"):
		node.visible = pause_state
