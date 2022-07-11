extends Control

var pause_state

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		pause_state = not get_tree().paused
		if pause_state:
			get_tree().paused = pause_state
			visible = pause_state
			for node in get_tree().get_nodes_in_group("Pause"):
				node.visible = pause_state
		else:
			pause_state = not get_tree().paused
			get_tree().paused = pause_state
			visible = pause_state
			for node in get_tree().get_nodes_in_group("Pause"):
				node.visible = pause_state
