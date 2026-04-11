shader_type canvas_item;

uniform vec2 tile_size = vec2(0.0, 0.0);
uniform float corner_radius : hint_range(0.0, 512.0) = 4.0;

void fragment() {
    vec2 size = tile_size.x > 0.0 ? tile_size : 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 pixel_pos = UV * size;
    vec2 d = abs(pixel_pos - size * 0.5) - size * 0.5 + vec2(corner_radius);
    float dist = length(max(d, 0.0)) - corner_radius;

    COLOR = texture(TEXTURE, UV);
    COLOR.a *= 1.0 - smoothstep(-0.5, 0.5, dist);
}
