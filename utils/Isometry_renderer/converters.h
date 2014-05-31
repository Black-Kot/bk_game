#ifndef CONVERTERS_H
#define CONVERTERS_H

#include "render.h"

void downscale_image( pixel_t *data, int width, int height, int times );

void light_texture( pixel_t *texture, float percent );

void rotate_model_x( model_t model );
void rotate_model_y( model_t model );
void rotate_model_z( model_t model );

void flip_model_x( model_t model );
void flip_model_y( model_t model );
void flip_model_z( model_t model );

#endif /* CONVERTERS_H */
