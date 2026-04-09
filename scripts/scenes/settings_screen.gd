extends Node2D

# ------------------------------------------------------------------
# Menu navigation functions
# ------------------------------------------------------------------

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/start_screen.tscn")
