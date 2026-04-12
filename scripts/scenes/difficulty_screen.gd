extends Node2D

# ------------------------------------------------------------------
# Menu navigation functions
# ------------------------------------------------------------------

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/start_screen.tscn")

func _on_easy_button_pressed():
	GameSettings.is_solo = true
	GameSettings.difficulty = GameSettings.Difficulty.EASY
	get_tree().change_scene_to_file("res://scenes/game/game_scene.tscn")

func _on_normal_button_pressed():
	GameSettings.is_solo = true
	GameSettings.difficulty = GameSettings.Difficulty.NORMAL
	get_tree().change_scene_to_file("res://scenes/game/game_scene.tscn")

func _on_hard_button_pressed():
	GameSettings.is_solo = true
	GameSettings.difficulty = GameSettings.Difficulty.HARD
	get_tree().change_scene_to_file("res://scenes/game/game_scene.tscn")
