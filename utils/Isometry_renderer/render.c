#include "render.h"
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

#define X_MULTIPLIER	0.4330127018925
#define ZERO_THRES		0.000001


typedef struct render_pixel_st
{
	pixel_t	value;
	float distance;
} render_pixel_t;


typedef struct surface_st
{
	float m_affine[2][3];
	float top, left, right, bottom;
	float dxa, dya, dbc;
	pixel_t (*texture)[16];
} surface_t;


typedef struct surf_list_st
{
	int surf_count;
	surface_t *data;
} surf_list_t;


pixel_t top_texture[16][16];
pixel_t left_texture[16][16];
pixel_t right_texture[16][16];


static inline float min( float a, float b )
	{ return (a < b) ? a : b; }

static inline float max( float a, float b )
	{ return (a > b) ? a : b; }

static int cmp_distance( const void *a, const void *b )
{
	return ( ((const render_pixel_t*)a)->distance > ((const render_pixel_t*)b)->distance ) ? 1 : -1;
}


static int makeAffineMatrix( float pts[6], surface_t *dst )
{
	float det, adj[3][3];
	int i;

	adj[0][0] = pts[3] - pts[5];
	adj[0][1] = pts[5] - pts[1];
	adj[0][2] = pts[1] - pts[3];
	adj[1][0] = pts[4] - pts[2];
	adj[1][1] = pts[0] - pts[4];
	adj[1][2] = pts[2] - pts[0];
	adj[2][0] = pts[2] * pts[5] - pts[3] * pts[4];
	adj[2][1] = pts[1] * pts[4] - pts[0] * pts[5];
	adj[2][2] = pts[0] * pts[3] - pts[1] * pts[2];
	det = adj[2][0] + adj[2][1] + adj[2][2];

	if( det < ZERO_THRES && det > -ZERO_THRES )
		return 0;

	for( i = 0; i < 3; ++i )
	{
		dst->m_affine[0][i] = ( dst->top * (adj[i][0] + adj[i][1]) + dst->bottom * adj[i][2] ) / det;
		dst->m_affine[1][i] = ( dst->left * (adj[i][0] + adj[i][2]) + dst->right * adj[i][1] ) / det;
	}

	return 1;
}


static int make_distance_equations( float h_tl, float h_tr, float h_bl, surface_t *dst )
{
	if( dst->right - dst->left < ZERO_THRES || dst->bottom - dst->top < ZERO_THRES )
		return 0;

	dst->dxa = (h_tr - h_tl) / (dst->right - dst->left);
	dst->dya = (h_bl - h_tl) / (dst->bottom - dst->top);
	dst->dbc = h_tl - dst->top * dst->dya - dst->left * dst->dxa;

	return 1;
}


static void box_to_surfaces( box_t src, surface_t *dest, int *pos )
{
	float dst_pts[6], h_tl, h_tr, h_bl;
	surface_t cur;

	cur.left = (min( src.y1, src.y2 ) + 0.5) * 16.0;
	cur.right = (max( src.y1, src.y2 ) + 0.5) * 16.0;
	cur.top = (min( src.x1, src.x2 ) + 0.5) * 16.0;
	cur.bottom = (max( src.x1, src.x2 ) + 0.5) * 16.0;

	h_tl = min( src.x1, src.x2 ) + min( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_tr = min( src.x1, src.x2 ) + max( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_bl = max( src.x1, src.x2 ) + min( src.y1, src.y2 ) + max( src.z1, src.z2 );

	dst_pts[0] = (min( src.y1, src.y2 ) - min( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[1] = (min( src.x1, src.x2 ) + min( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[2] = (max( src.y1, src.y2 ) - min( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[3] = (min( src.x1, src.x2 ) + max( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[4] = (min( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[5] = (max( src.x1, src.x2 ) + min( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;

	if( makeAffineMatrix( dst_pts, &cur ) && make_distance_equations( h_tl, h_tr, h_bl, &cur ) )
	{
		cur.texture = top_texture;
		dest[(*pos)++] = cur;
	}

	cur.left = (min( src.y1, src.y2 ) + 0.5) * 16.0;
	cur.right = (max( src.y1, src.y2 ) + 0.5) * 16.0;
	cur.top = (0.5 - max( src.z1, src.z2 )) * 16.0;
	cur.bottom = (0.5 - min( src.z1, src.z2 )) * 16.0;

	h_tl = max( src.x1, src.x2 ) + min( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_tr = max( src.x1, src.x2 ) + max( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_bl = max( src.x1, src.x2 ) + min( src.y1, src.y2 ) + min( src.z1, src.z2 );

	dst_pts[0] = (min( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[1] = (max( src.x1, src.x2 ) + min( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[2] = (max( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[3] = (max( src.x1, src.x2 ) + max( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[4] = (min( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[5] = (max( src.x1, src.x2 ) + min( src.y1, src.y2 )) * 0.25 - min( src.z1, src.z2 ) * 0.5 + 0.5;

	if( makeAffineMatrix( dst_pts, &cur ) && make_distance_equations( h_tl, h_tr, h_bl, &cur ) )
	{
		cur.texture = left_texture;
		dest[(*pos)++] = cur;
	}

	cur.left = (0.5 - max( src.x1, src.x2 )) * 16.0;
	cur.right = (0.5 - min( src.x1, src.x2 )) * 16.0;
	cur.top = (0.5 - max( src.z1, src.z2 )) * 16.0;
	cur.bottom = (0.5 - min( src.z1, src.z2 )) * 16.0;

	h_tl = max( src.x1, src.x2 ) + max( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_tr = min( src.x1, src.x2 ) + max( src.y1, src.y2 ) + max( src.z1, src.z2 );
	h_bl = max( src.x1, src.x2 ) + max( src.y1, src.y2 ) + min( src.z1, src.z2 );

	dst_pts[0] = (max( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[1] = (max( src.x1, src.x2 ) + max( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[2] = (max( src.y1, src.y2 ) - min( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[3] = (min( src.x1, src.x2 ) + max( src.y1, src.y2 )) * 0.25 - max( src.z1, src.z2 ) * 0.5 + 0.5;
	dst_pts[4] = (max( src.y1, src.y2 ) - max( src.x1, src.x2 )) * X_MULTIPLIER + 0.5;
	dst_pts[5] = (max( src.x1, src.x2 ) + max( src.y1, src.y2 )) * 0.25 - min( src.z1, src.z2 ) * 0.5 + 0.5;

	if( makeAffineMatrix( dst_pts, &cur ) && make_distance_equations( h_tl, h_tr, h_bl, &cur ) )
	{
		cur.texture = right_texture;
		dest[(*pos)++] = cur;
	}
}


static surf_list_t model_to_surf_list( model_t model )
{
	surf_list_t dest;
	int i;

	dest.surf_count = 0;
	dest.data = malloc( model.box_count * sizeof(surface_t) * 3 );
	if( !dest.data )
	{
		fprintf( stderr, "Memory allocation error\n" );
		return dest;
	}

	for( i = 0; i < model.box_count; ++i )
		box_to_surfaces( model.data[i], dest.data, &dest.surf_count );

	if( dest.surf_count == 0 )
		free( dest.data );

	return dest;
}


static render_pixel_t get_pixel_at( surface_t *surf, float x, float y )
{
	render_pixel_t dest;
	float tx, ty;


	ty = x * surf->m_affine[0][0] + y * surf->m_affine[0][1] + surf->m_affine[0][2];
	tx = x * surf->m_affine[1][0] + y * surf->m_affine[1][1] + surf->m_affine[1][2];

	if( tx < surf->left || tx > surf->right || ty < surf->top || ty > surf->bottom )
		dest.value = 0;
	else
		dest.value = surf->texture[(int)ty][(int)tx];

	dest.distance = tx * surf->dxa + ty * surf->dya + surf->dbc;

	return dest;
}


static pixel_t mix_colors( pixel_t front, pixel_t rear )
{
	unsigned int alpha, r, g, b, a;

	alpha = front >> 24;

	if( alpha == 0 )
		return rear;

	if( alpha == 0xFF )
		return front;

	a = 255 - (255 - alpha) * (255 - (rear >> 24)) / 255;
	r = ( ((front >> 16) & 0xFF) * alpha + ((rear >> 16) & 0xFF) * (255 - alpha) ) / 255;
	g = ( ((front >> 8) & 0xFF) * alpha + ((rear >> 8) & 0xFF) * (255 - alpha) ) / 255;
	b = ( (front & 0xFF) * alpha + (rear & 0xFF) * (255 - alpha) ) / 255;

	return (a << 24) | (r << 16) | (g << 8) | b;
}


pixel_t *render_model( model_t model, int resolution )
{
	int x, y, pos, i;
	surf_list_t surflist;
	render_pixel_t *spixels;
	pixel_t cur_color;
	pixel_t *dest;

	surflist = model_to_surf_list( model );
	if( surflist.surf_count == 0 )
	{
		fprintf( stderr, "Empty model\n" );
		return NULL;
	}

	spixels = malloc( surflist.surf_count * sizeof(render_pixel_t) );
	dest = malloc( resolution * resolution * sizeof(pixel_t) );
	if( !spixels || !dest )
	{
		fprintf( stderr, "Memory allocation error\n" );
		if( spixels )					free( spixels );
		if( dest )						free( dest );
		if( surflist.surf_count != 0 )	free( surflist.data );
		return NULL;
	}

	pos = 0;
	for( y = 0; y < resolution; ++y )
		for( x = 0; x < resolution; ++x )
		{
			for( i = 0; i < surflist.surf_count; ++i )
				spixels[i] = get_pixel_at( &surflist.data[i], (float)x / resolution, (float)y / resolution );

			if( surflist.surf_count > 1 )
				qsort( spixels, surflist.surf_count, sizeof(render_pixel_t), cmp_distance );

			cur_color = 0;
			for( i = 0; i < surflist.surf_count; ++i )
				cur_color = mix_colors( spixels[i].value, cur_color );

			dest[pos++] = cur_color;
		}

	free( spixels );
	free( surflist.data );
	return dest;
}
