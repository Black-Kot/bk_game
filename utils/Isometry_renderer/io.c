#include "io.h"
#include <stdio.h>
#include <malloc.h>
#include <png.h>


int loadTexture( char *filename, pixel_t dest[16][16] )
{
	int ret_code;
	png_byte header[8];
	FILE *fp;

	png_structp png_ptr;
	png_infop info_ptr = NULL;

	int width, height;
	png_byte color_type;
	png_byte bit_depth;

	png_byte data[2048];
	png_bytep row_pointers[16];

	int x, y, pos;
	int color_shift, divisor;
	unsigned char r, g, b, a;


	ret_code = 0;

	fp = fopen( filename, "rb" );
	if( !fp )
	{
		fprintf(stderr, "Cannot open file %s\n", filename );
		goto cleanup;
	}

	fread( header, 1, 8, fp );
	if( png_sig_cmp( header, 0, 8 ) )
	{
		fprintf(stderr, "Texture file must be PNG image of size 16x16 pixels\n");
		goto cleanup;
	}

	png_ptr = png_create_read_struct( PNG_LIBPNG_VER_STRING, NULL, NULL, NULL );
	info_ptr = png_create_info_struct( png_ptr );
	if( !png_ptr || !info_ptr )
	{
		fprintf( stderr, "Memory allocation error\n" );
		goto cleanup;
	}

	if( setjmp( png_jmpbuf( png_ptr ) ) )
	{
		fprintf( stderr, "Error during init_io\n" );
		goto cleanup;
	}

	png_init_io( png_ptr, fp );
	png_set_sig_bytes( png_ptr, 8 );
	png_read_info( png_ptr, info_ptr );

	width = png_get_image_width( png_ptr, info_ptr );
	height = png_get_image_height( png_ptr, info_ptr );
	if( width != 16 || height != 16 )
	{
		fprintf(stderr, "Texture file must be PNG image of size 16x16 pixels\n");
		goto cleanup;
	}

	color_type = png_get_color_type( png_ptr, info_ptr );
	bit_depth = png_get_bit_depth( png_ptr, info_ptr );
	if( (color_type & PNG_COLOR_MASK_PALETTE) || bit_depth > 16 )
	{
		fprintf(stderr, "Unsupported color scheme in texture file\n");
		goto cleanup;
	}

	png_read_update_info( png_ptr, info_ptr );

	if( setjmp( png_jmpbuf( png_ptr ) ) )
	{
		fprintf(stderr, "Error reading texture file\n");
		goto cleanup;
	}

	for( y = 0; y < 16; ++y )
		row_pointers[y] = &data[y*128];

	png_read_image( png_ptr, row_pointers );

	a = 0xFF;
	color_shift = (bit_depth >= 8) ? 0 : 8 - bit_depth;
	divisor = (0x100 >> color_shift) - 1;

	for( y = 0; y < 16; ++y )
	{
		pos = bit_depth >> 8;
		for( x = 0; x < 16; ++x )
		{
			b = ( ((row_pointers[y][pos >> 3]) << (pos & 7) ) >> color_shift) * 255 / divisor;
			pos += bit_depth;

			if( color_type & PNG_COLOR_MASK_COLOR )
			{
				g = ( ((row_pointers[y][pos >> 3]) << (pos & 7) ) >> color_shift) * 255 / divisor;
				pos += bit_depth;
				r = ( ((row_pointers[y][pos >> 3]) << (pos & 7) ) >> color_shift) * 255 / divisor;
				pos += bit_depth;
			}
			else
				r = g = b;

			if( color_type & PNG_COLOR_MASK_ALPHA )
			{
				a = ( ((row_pointers[y][pos >> 3]) << (pos & 7) ) >> color_shift) * 255 / divisor;
				pos += bit_depth;
			}

			dest[y][x] = ((pixel_t)a << 24) | ((pixel_t)r << 16) | ((pixel_t)g << 8) | (pixel_t)b;
		}
	}

	ret_code = 1;

cleanup:
	if( fp )		fclose(fp);
	if( info_ptr )	png_free_data( png_ptr, info_ptr, PNG_FREE_ALL, -1 );
	if( png_ptr )	png_destroy_read_struct( &png_ptr, NULL, NULL );

	return ret_code;
}


void saveImage( char *filename, pixel_t *image, int width, int height )
{
	int i;
	FILE *fp;
	png_structp png_ptr;
	png_infop info_ptr = NULL;

	fp = fopen( filename, "wb" );
	if( !fp )
	{
		fprintf( stderr, "Could not open file %s for writing\n", filename );
		goto cleanup;
	}

	png_ptr = png_create_write_struct( PNG_LIBPNG_VER_STRING, NULL, NULL, NULL );
	info_ptr = png_create_info_struct( png_ptr );
	if( !png_ptr || !info_ptr )
	{
		fprintf( stderr, "Memory allocation error\n" );
		goto cleanup;
	}

	if( setjmp( png_jmpbuf( png_ptr ) ) )
	{
		fprintf(stderr, "Error during png creation\n");
		goto cleanup;
	}

	png_init_io( png_ptr, fp );

	png_set_IHDR( png_ptr, info_ptr, width, height,
				  8, PNG_COLOR_TYPE_RGB_ALPHA, PNG_INTERLACE_NONE,
				  PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

	png_write_info( png_ptr, info_ptr );

	for( i = 0; i < height; ++i )
		png_write_row( png_ptr, (png_bytep)(image + width*i) );

	png_write_end( png_ptr, NULL );

cleanup:
	if( fp )		fclose(fp);
	if( info_ptr )	png_free_data( png_ptr, info_ptr, PNG_FREE_ALL, -1 );
	if( png_ptr )	png_destroy_write_struct( &png_ptr, NULL );
}


int load_model( char *filename, model_t *dest )
{
	FILE *fp;
	int i;

	fp = fopen( filename, "r" );
	if( !fp )
	{
		fprintf( stderr, "Cannot open model file: %s\n", filename );
		goto error;
	}

	fscanf( fp, "%d", &dest->box_count );
	dest->data = malloc( dest->box_count * sizeof(box_t) );

	for( i = 0; i < dest->box_count; ++i )
	{
		fscanf( fp, "%f %f %f %f %f %f", &dest->data[i].y2, &dest->data[i].z1,
										 &dest->data[i].x2, &dest->data[i].y1,
										 &dest->data[i].z2, &dest->data[i].x1);
		dest->data[i].x1 = -dest->data[i].x1;
		dest->data[i].x2 = -dest->data[i].x2;
		dest->data[i].y1 = -dest->data[i].y1;
		dest->data[i].y2 = -dest->data[i].y2;
	}

	fclose( fp );

	return 1;

error:
	if(fp)
	{
		fclose( fp );
		if( dest->data )
			free( dest->data );
	}

	dest->box_count = 0;
	return 0;
}


void free_model( model_t model )
{
	if( model.box_count != 0 )
		free( model.data );
}
