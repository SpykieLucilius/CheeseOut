extends StaticBody2D

const TEXTURES = [
	preload("res://assets/img/sprites/Cheese_Tile1.png"),
	preload("res://assets/img/sprites/Cheese_Tile2.png"),
	preload("res://assets/img/sprites/Cheese_Tile3.png"),
]

func _ready():
	var sprite = $CheeseSprite
	sprite.texture = TEXTURES[randi() % TEXTURES.size()]
	var tex_size = sprite.texture.get_size()
	sprite.scale = Vector2(80.0 / tex_size.x, 20.0 / tex_size.y)
	sprite.material.set_shader_parameter("tile_size", Vector2(80.0, 20.0))
	sprite.material.set_shader_parameter("corner_radius", 4.0)
