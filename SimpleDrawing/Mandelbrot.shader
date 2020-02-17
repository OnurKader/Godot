shader_type canvas_item;

vec2 complexSquare(vec2 c_num)
{
	return vec2(c_num.x * c_num.x - c_num.y * c_num.y, 2.0 * c_num.x * c_num.y);
}

vec2 mandelbrot(vec2 z, vec2 c)
{
	return complexSquare(z) + c;
}

const float x_off = 0.7544;
const float y_off = 0.1058205;
const uint MAX_ITER_COUNT = uint(256);
uniform float ZOOM_AMOUNT: hint_range(0.0, 3.1415296) = 2.0;
uniform vec2 initial_z;
uniform float time = 0.0;

void fragment()
{
	vec2 z = initial_z;
	vec2 c = UV.xy - vec2(0.5);
	c /= pow(ZOOM_AMOUNT, time - 2.718281828);
	c.y *= -1.0;
	c.y += y_off;
	c.x -= sqrt(x_off * x_off - y_off * y_off);

	float z_mag = 0.0;
	uint num_of_iters = uint(0);
	for(uint i = uint(0); i < MAX_ITER_COUNT; ++i)
	{
		++num_of_iters;
		z = mandelbrot(z, c);
		z_mag = length(z);
		
		if(z_mag >= 2.0){
			break; 
		}
	}
	COLOR = vec4(vec3(1.0 - float(num_of_iters)/float(MAX_ITER_COUNT)), 1.0);
}