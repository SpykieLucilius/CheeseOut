extends CharacterBody2D

# ------------------------------------------------------------------
# Player 2 and computer variables and process
# ------------------------------------------------------------------

@export var input_left: String = "P2_Left"
@export var input_right: String = "P2_Right"

const SPEED = 400.0
const PADDLE_HALF_WIDTH = 80.0
const WALL_LEFT = 143.0
const WALL_RIGHT = 1009.0

# Computer state
var is_ai: bool = false
var ai_speed: float = 260.0
var ai_error: float = 50.0
var ai_react_delay: float = 0.25
var ai_target_x: float = 576.0
var ai_error_offset: float = 0.0
var ai_react_timer: float = 0.0

func _physics_process(delta):
	if is_ai:
		_ai_process(delta)
	else:
		_human_process()

# ------------------------------------------------------------------
# AI setup
# ------------------------------------------------------------------

func setup_ai():
	match GameSettings.difficulty:
		GameSettings.Difficulty.EASY:
			ai_speed = 200.0
			ai_error = 80.0
			ai_react_delay = 0.6
		GameSettings.Difficulty.NORMAL:
			ai_speed = 300.0
			ai_error = 30.0
			ai_react_delay = 0.25
		GameSettings.Difficulty.HARD:
			ai_speed = 400.0
			ai_error = 0.0
			ai_react_delay = 0.0
	ai_target_x = position.x
	ai_error_offset = randf_range(-ai_error, ai_error)	

# ------------------------------------------------------------------
# human player process
# ------------------------------------------------------------------

func _human_process():
	var direction = 0
	if Input.is_action_pressed(input_left):
		direction = -1
	if Input.is_action_pressed(input_right):
		direction = 1
	velocity.x = direction * SPEED
	velocity.y = 0
	move_and_slide()
	position.x = clamp(position.x, WALL_LEFT + PADDLE_HALF_WIDTH, WALL_RIGHT - PADDLE_HALF_WIDTH)

# ------------------------------------------------------------------
# AI player process
# ------------------------------------------------------------------

func _ai_process(delta):
	ai_react_timer -= delta
	if ai_react_timer <= 0.0:
		ai_react_timer = ai_react_delay
		_ai_update_target()

	var actual_target = clamp(ai_target_x + ai_error_offset, WALL_LEFT + PADDLE_HALF_WIDTH, WALL_RIGHT - PADDLE_HALF_WIDTH)
	var dist = actual_target - position.x
	velocity.x = 0.0 if abs(dist) < 4.0 else sign(dist) * ai_speed
	velocity.y = 0
	move_and_slide()
	position.x = clamp(position.x, WALL_LEFT + PADDLE_HALF_WIDTH, WALL_RIGHT - PADDLE_HALF_WIDTH)

# ------------------------------------------------------------------
# AI target update function
# ------------------------------------------------------------------

func _ai_update_target():
	var mice = get_tree().get_nodes_in_group("mouse_ball")
	if mice.is_empty():
		return

	var threat = null
	var min_time = INF
	for m in mice:
		if m.direction.y < 0.0:
			var t = (position.y - m.global_position.y) / (m.direction.y * m.speed)
			if t > 0.0 and t < min_time:
				min_time = t
				threat = m

	if threat == null:
		match GameSettings.difficulty:
			GameSettings.Difficulty.HARD:
				ai_target_x = _remaining_cheese_center()
				ai_error_offset = 0.0
			_:
				ai_target_x = lerp(ai_target_x, 576.0, 0.1)
		return

	# React based on difficulty
	var new_x: float
	match GameSettings.difficulty:
		GameSettings.Difficulty.EASY:
			new_x = threat.global_position.x
		GameSettings.Difficulty.NORMAL:
			var pred = _predict_mouse_x(threat)
			new_x = lerp(threat.global_position.x, pred, 0.5)
		GameSettings.Difficulty.HARD:
			var predicted_x = _predict_mouse_x(threat)
			if _threatens_cheese(predicted_x):
				new_x = predicted_x
			else:
				new_x = _remaining_cheese_center()
		_:
			new_x = threat.global_position.x

	ai_target_x = new_x
	ai_error_offset = randf_range(-ai_error, ai_error)

func _predict_mouse_x(mouse):
	var dir = mouse.direction
	if dir == Vector2.ZERO or dir.y >= 0.0:
		return mouse.global_position.x
	var t = (position.y - mouse.global_position.y) / (dir.y * mouse.speed)
	if t < 0.0:
		return mouse.global_position.x

	var raw_x = mouse.global_position.x + dir.x * mouse.speed * t

	const BOUNCE_LEFT = 286.0
	const BOUNCE_RIGHT = 866.0
	var width = BOUNCE_RIGHT - BOUNCE_LEFT
	var rx = fmod(raw_x - BOUNCE_LEFT, 2 * width)

	if rx < 0.0:
		rx += 2 * width
	if rx > width:
		rx = 2 * width - rx
	return BOUNCE_LEFT + rx


func _threatens_cheese(predicted_x: float) -> bool:
	for cheese in get_tree().get_nodes_in_group("cheese_p1"):
		if abs(cheese.global_position.x - predicted_x) < 80.0:
			return true
	return false

func _remaining_cheese_center() -> float:
	var tiles = get_tree().get_nodes_in_group("cheese_p1")
	if tiles.is_empty():
		return 576.0
	var sum = 0.0
	for tile in tiles:
		sum += tile.global_position.x
	return sum / tiles.size()

# ------------------------------------------------------------------
# Ready function
# ------------------------------------------------------------------

func _ready():
	var sprite = $Player2Sprite
	var tex_size = sprite.texture.get_size()
	sprite.scale = Vector2(160.0 / tex_size.x, 20.0 / tex_size.y)
	sprite.flip_v = true
	is_ai = GameSettings.is_solo
	if is_ai:
		setup_ai()
