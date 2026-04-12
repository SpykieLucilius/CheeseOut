extends Node2D

# ------------------------------------------------------------------
# Menu navigation functions
# ------------------------------------------------------------------

func _on_back_button_pressed():
	game_over = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/start_screen.tscn")

# ------------------------------------------------------------------
# Cheese tiles spawn and placement functions
# ------------------------------------------------------------------

const CheeseScene = preload("res://scenes/game/cheese.tscn")
const COLUMNS = 6
const ROWS = 3
const CHEESE_WIDTH = 80
const CHEESE_HEIGHT = 20
const GAP_X = 10
const GAP_Y = 10

const PADDLE2_Y = 150.0
const PADDLE1_Y = 498.0
const MARGIN = 20.0
var cheese_grid_height = ROWS * CHEESE_HEIGHT + (ROWS - 1) * GAP_Y

func spawn_cheese():
	var total_width = COLUMNS * CHEESE_WIDTH + (COLUMNS - 1) * GAP_X
	var start_x = (1152.0 / 2.0) - (total_width / 2.0) + (CHEESE_WIDTH / 2.0)

	# player 1 cheese placement
	var p1_start_y = PADDLE2_Y - MARGIN - cheese_grid_height + CHEESE_HEIGHT / 2.0
	for row in range(ROWS):
		for col in range(COLUMNS):
			var cheese = CheeseScene.instantiate()
			cheese.position = Vector2(
				start_x + col * (CHEESE_WIDTH + GAP_X),
				p1_start_y + row * (CHEESE_HEIGHT + GAP_Y)
			)
			cheese.add_to_group("cheese_p1")
			add_child(cheese)
	
	# player 2 cheese placement
	var p2_start_y = PADDLE1_Y + MARGIN + CHEESE_HEIGHT / 2.0
	for row in range(ROWS):
		for col in range(COLUMNS):
			var cheese = CheeseScene.instantiate()
			cheese.position = Vector2(
				start_x + col * (CHEESE_WIDTH + GAP_X),
				p2_start_y + row * (CHEESE_HEIGHT + GAP_Y)
			)
			cheese.add_to_group("cheese_p2")
			add_child(cheese)

# ------------------------------------------------------------------
# Mouse ball spawn functions
# ------------------------------------------------------------------

const MouseScene = preload("res://scenes/game/mouse.tscn")
const MOUSE_HEIGHT = 20
const MOUSE_WIDTH = 20
var MOUSE_SPAWN_LOCATIONS = [
	Vector2(1152.0 / 2.0, PADDLE1_Y - MARGIN - MOUSE_HEIGHT / 2.0), 
	Vector2(1152.0 / 2.0, PADDLE2_Y + MARGIN + MOUSE_HEIGHT / 2.0)  
]
var mouse_count = 2

func spawn_mouse():
	for i in range(mouse_count):
		var mouse = MouseScene.instantiate()
		mouse.position = MOUSE_SPAWN_LOCATIONS[i % MOUSE_SPAWN_LOCATIONS.size()]
		mouse.add_to_group("mouse_ball")
		add_child(mouse)

# ------------------------------------------------------------------
# Restart game function
# ------------------------------------------------------------------

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# ------------------------------------------------------------------
# Win condition function
# ------------------------------------------------------------------

var game_over = false

func check_win():
	if game_over:
		return
	if get_tree().get_nodes_in_group("cheese_p1").size() == 0:
		show_winner("Player 2")
	elif get_tree().get_nodes_in_group("cheese_p2").size() == 0:
		show_winner("Player 1")

func show_winner(winner: String):
	game_over = true
	get_tree().paused = true
	$UI/WinScreen/WinLabel.text = winner + " wins !"
	$UI/WinScreen.visible = true

# ------------------------------------------------------------------
# Ready function
# ------------------------------------------------------------------

func _ready():
	spawn_cheese()
	spawn_mouse()

	child_exiting_tree.connect(func(node):
		if node.is_in_group("cheese"):
			check_win.call_deferred()
	)
