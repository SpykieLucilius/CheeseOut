extends Node2D

# ------------------------------------------------------------------
# Menu navigation functions
# ------------------------------------------------------------------

func _on_setting_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/settings_screen.tscn")

func _on_games_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/other_game_screen.tscn")

func _on_solo_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/difficulty_screen.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
