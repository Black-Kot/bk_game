#include "converters.h"


void downscale_image( pixel_t *data, int width, int height, int times )
{
	unsigned int square, pos;
	unsigned int a, r, g, b;
	int x, y, i, j;
	pixel_t tmp;

	square = times * times;
	pos = 0;

	for( y = 0; y < height; y += times )
		for( x = 0; x < width; x += times )
		{
			a = r = g = b = 0;
			for( i = 0; i < times; ++i )
				for( j = 0; j < times; ++j )
				{
					tmp = data[ (y + i)*width + x + j ];
					a += (tmp >> 24) & 0xFF;
					b += (tmp >> 16) & 0xFF;
					g += (tmp >> 8) & 0xFF;
					r += tmp & 0xFF;
				}
			data[pos++] = ((a / square) << 24) |
						  ((b / square) << 16) |
						  ((g / square) << 8) |
						  (r / square);
		}
}


void light_texture( pixel_t *texture, float percent )
{
	float coeff;
	unsigned int i, a, r, g, b;

	if( percent > 0 )
	{
		coeff = 1.0 - percent;
		for( i = 0; i < 256; ++i )
		{
			a = texture[i] & 0xFF000000;
			r = (255 - ((texture[i] >> 16) & 0xFF)) * coeff;
			g = (255 - ((texture[i] >> 8) & 0xFF)) * coeff;
			b = (255 - (texture[i] & 0xFF)) * coeff;
			texture[i] = a | ((255 - r) << 16) | ((255 - g) << 8) | (255 - b);
		}
	}
	else
	{
		coeff = 1.0 + percent;
		for( i = 0; i < 256; ++i )
		{
			a = texture[i] & 0xFF000000;
			r = ((texture[i] >> 16) & 0xFF) * coeff;
			g = ((texture[i] >> 8) & 0xFF) * coeff;
			b = (texture[i] & 0xFF) * coeff;
			texture[i] = a | (r << 16) | (g << 8) | b;
		}
	}
}


void rotate_model_x( model_t model )
{
	int i;
	float tmp;
	for( i = 0; i < model.box_count; ++i )
	{
		tmp = model.data[i].y1;
		model.data[i].y1 = -model.data[i].z1;
		model.data[i].z1 = tmp;

		tmp = model.data[i].y2;
		model.data[i].y2 = -model.data[i].z2;
		model.data[i].z2 = tmp;
	}
}


void rotate_model_y( model_t model )
{
	int i;
	float tmp;
	for( i = 0; i < model.box_count; ++i )
	{
		tmp = model.data[i].x1;
		model.data[i].x1 = model.data[i].z1;
		model.data[i].z1 = -tmp;

		tmp = model.data[i].x2;
		model.data[i].x2 = model.data[i].z2;
		model.data[i].z2 = -tmp;
	}
}


void rotate_model_z( model_t model )
{
	int i;
	float tmp;
	for( i = 0; i < model.box_count; ++i )
	{
		tmp = model.data[i].y1;
		model.data[i].y1 = model.data[i].x1;
		model.data[i].x1 = -tmp;

		tmp = model.data[i].y2;
		model.data[i].y2 = model.data[i].x2;
		model.data[i].x2 = -tmp;
	}
}


void flip_model_x( model_t model )
{
	int i;
	for( i = 0; i < model.box_count; ++i )
	{
		model.data[i].x1 = -model.data[i].x1;
		model.data[i].x2 = -model.data[i].x2;
	}
}


void flip_model_y( model_t model )
{
	int i;
	for( i = 0; i < model.box_count; ++i )
	{
		model.data[i].z1 = -model.data[i].z1;
		model.data[i].z2 = -model.data[i].z2;
	}
}


void flip_model_z( model_t model )
{
	int i;
	for( i = 0; i < model.box_count; ++i )
	{
		model.data[i].z1 = -model.data[i].z1;
		model.data[i].z2 = -model.data[i].z2;
	}
}
