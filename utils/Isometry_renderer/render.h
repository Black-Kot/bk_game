#ifndef RENDER_H
#define RENDER_H

typedef unsigned int pixel_t;

extern pixel_t top_texture[16][16];
extern pixel_t left_texture[16][16];
extern pixel_t right_texture[16][16];


typedef struct box_st
{
	float x1, y1, z1;
	float x2, y2, z2;
} box_t;


typedef struct model_st
{
	int box_count;
	box_t *data;
} model_t;


pixel_t *render_model( model_t model, int resolution );

#endif /* RENDER_H */
