shader_type canvas_item;

uniform float width = 0.5;
uniform float speed = 5.0;
uniform float height = 0.5;

void vertex()
{
	VERTEX.x += width * sin(TIME);
	VERTEX.y += height * sin(TIME);
}
