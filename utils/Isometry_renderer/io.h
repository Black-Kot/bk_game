#ifndef RENDERER_IO_H
#define RENDERER_IO_H

#include "render.h"

int loadTexture( char *filename, pixel_t dest[16][16] );
void saveImage( char *filename, pixel_t *image, int width, int height );

int load_model( char *filename, model_t *dest );
void free_model( model_t bs );

#endif /* RENDERER_IO_H */
