extends CharacterBody2D

# ------------------------------------------------------------------
# Player 1 movement functions
# ------------------------------------------------------------------

@export var input_left: String = "P1_Left"
@export var input_right: String = "P1_Right"

const SPEED = 400.0
const PADDLE_HALF_WIDTH = 80.0
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

# ------------------------------------------------------------------
# Ready function
# ------------------------------------------------------------------

func _ready():
	var sprite = $Player1Sprite
	var tex_size = sprite.texture.get_size()
	sprite.scale = Vector2(160.0 / tex_size.x, 20.0 / tex_size.y)
