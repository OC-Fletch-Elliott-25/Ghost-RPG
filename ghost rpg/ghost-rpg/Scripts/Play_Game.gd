extends Control

#When the play button is pressed, the game takes the player straight to the battle menu I've made.
#I need to change this to Nino's overworld when we reconvene.
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Battle_3.tscn")

#When the "exit" button is pressed, the game shuts itself down.
func _on_exit_pressed():
	get_tree().quit()
