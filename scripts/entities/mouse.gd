extends CharacterBody2D

# ------------------------------------------------------------------
# Mouse movement functions
# ------------------------------------------------------------------

var speed = 400.0
var direction = Vector2.ZERO
const PADDLE_HALF_WIDTH = 80.0
const PADDLE_HALF_HEIGHT = 10.0
const BALL_HALF_X = 10.0
const BALL_HALF_Y = 26.0

const TEX_NORMAL = preload("res://assets/img/sprites/WhiteMouse.png")
const TEX_HIT = preload("res://assets/img/sprites/WhiteMouseHit.png")

var hit_timer = 0.0
const HIT_DURATION = 0.1

func _physics_process(_delta):
	if hit_timer > 0.0:
		hit_timer -= _delta
		if hit_timer <= 0.0:
			$MouseSprite.texture = TEX_NORMAL

	var collision = move_and_collide(direction * speed * _delta)
	if collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if "Player" in collider.name:
			if abs(normal.x) > abs(normal.y):
				direction.x = -direction.x
			else:
				var hit_offset = (collision.get_position().x - collider.global_position.x) / PADDLE_HALF_WIDTH
				direction = Vector2(clamp(hit_offset, -1.0, 1.0), -sign(direction.y)).normalized()
				var side = sign(position.y - collider.global_position.y)
				if side == 0:
					side = 1
				position.y = collider.global_position.y + side * (PADDLE_HALF_HEIGHT + BALL_HALF_Y)
		elif collider.is_in_group("back_wall"):
			var holes = [get_parent().get_node("MouseHoleLeft"), get_parent().get_node("MouseHoleRight")]
			var hole = holes[randi() % 2]
			position = hole.global_position
			var dir_x = 1.0 if hole.name == "MouseHoleLeft" else -1.0
			direction = Vector2(dir_x, randf_range(-0.5, 0.5)).normalized()
		else:
			direction = direction.bounce(normal)
			_show_hit()
			if collider.is_in_group("cheese"):
				collider.queue_free()
	if direction != Vector2.ZERO:
		$MouseSprite.rotation = direction.angle() + PI / 2.0

func _show_hit():
	$MouseSprite.texture = TEX_HIT
	hit_timer = HIT_DURATION
		
# ------------------------------------------------------------------
# ready function
# ------------------------------------------------------------------	
	
func _ready():
	var tex_size = TEX_NORMAL.get_size()
	var s = 52.0 / tex_size.y
	$MouseSprite.scale = Vector2(s, s)
	var screen_center_y = get_viewport_rect().size.y / 2
	var dir_y = -1.0 if position.y > screen_center_y else 1.0
	direction = Vector2(randf_range(-0.8, 0.8), dir_y).normalized()
