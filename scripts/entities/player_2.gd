extends CharacterBody2D

# ------------------------------------------------------------------
# Player 2 movement functions
# ------------------------------------------------------------------

@export var input_left: String = "P2_Left"
@export var input_right: String = "P2_Right"

const SPEED = 400.0
const PADDLE_HALF_WIDTH = 40.0
const WALL_LEFT = 143.0
const WALL_RIGHT = 1009.0

func _physics_process(_delta):
	var direction = 0
	if Input.is_action_pressed(input_left):
		direction = -1
	if Input.is_action_pressed(input_right):
		direction = 1

	velocity.x = direction * SPEED
	velocity.y = 0
	move_and_slide()

	position.x = clamp(position.x, WALL_LEFT + PADDLE_HALF_WIDTH, WALL_RIGHT - PADDLE_HALF_WIDTH)
