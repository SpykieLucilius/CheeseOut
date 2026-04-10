extends CharacterBody2D

# ------------------------------------------------------------------
# Mouse movement functions
# ------------------------------------------------------------------

var speed = 200.0
var direction = Vector2.ZERO
const PADDLE_HALF_WIDTH = 40.0
const PADDLE_HALF_HEIGHT = 5.0
const BALL_HALF = 10.0

func _physics_process(_delta):
	var collision = move_and_collide(direction * speed * _delta)
	if collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if "Player" in collider.name:
			if abs(normal.x) > abs(normal.y):
				var side = sign(position.y - collider.global_position.y)
				if side == 0:
					side = 1
				position.y = collider.global_position.y + side * (PADDLE_HALF_HEIGHT + BALL_HALF)
				direction.y = -direction.y
			else:
				var hit_offset = (collision.get_position().x - collider.global_position.x) / PADDLE_HALF_WIDTH
				direction = Vector2(clamp(hit_offset, -1.0, 1.0), -sign(direction.y)).normalized()
		else:
			direction = direction.bounce(normal)
			if collider.is_in_group("cheese"):
				collider.queue_free()
		
# ------------------------------------------------------------------
# ready function
# ------------------------------------------------------------------	
	
func _ready():
	var screen_center_y = get_viewport_rect().size.y / 2
	var dir_y = -1.0 if position.y > screen_center_y else 1.0
	direction = Vector2(randf_range(-0.5, 0.5), dir_y).normalized()
