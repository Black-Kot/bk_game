#include "render.h"
#include "converters.h"
#include "io.h"

#include <stdio.h>
#include <malloc.h>
#include <string.h>

#define SHOW_HELP { ret_code = 2; help( *argv ); goto cleanup; }
#define ASSERT_ARGUMENT if( i + 1 >= argc ) { ret_code = 2; argument_missing_error( argv[i] ); goto cleanup; }

void help( char *progname )
{
	printf( "Usage: %s <minetest.model> <texture.png> <resolution> <output.png> [parameters]\n"
			"Resolution is integer. Output image will be square.\n"
			"Parameters:\n\t-left-tex <texture.png> - left side texture\n\t"
			"-right-tex <texture.png> - right side texture\n\t"
			"-factor <x> - render x times larger image and downscale it before output\n\t"
			"-rotx, -roty, -rotz - rotate image along axis clockwise\n\t"
			"-flipx, -flipy, -flipz - flip image along axis\n", progname );
}


void argument_missing_error( char *param )
{
	fprintf( stderr, "Argument \"%s\" requires argument\n", param );
}


int main( int argc, char** argv )
{
	model_t model;
	pixel_t *result = NULL;
	unsigned int resolution, factor = 1;
	int i, ret_code = 1;

	model.box_count = 0;

	if( argc < 5 )
		SHOW_HELP;

	if( !load_model( argv[1], &model ) )
		goto cleanup;

	if( !loadTexture( argv[2], top_texture ) )
		goto cleanup;

	memcpy( left_texture, top_texture, sizeof(top_texture) );
	memcpy( right_texture, left_texture, sizeof(top_texture) );

	sscanf( argv[3], "%u", &resolution );
	if( resolution < 8 || resolution > 1024 )
	{
		fprintf( stderr, "Image resolution out of range: 16-1024\n" );
		goto cleanup;
	}

	for( i = 5; i < argc; ++i )
		if( strcmp( argv[i], "-left-tex" ) == 0 )
		{
			ASSERT_ARGUMENT;
			if( !loadTexture( argv[++i], left_texture ) )
				goto cleanup;
		}
		else if( strcmp( argv[i], "-right-tex" ) == 0 )
		{
			ASSERT_ARGUMENT;
			if( !loadTexture( argv[++i], right_texture ) )
				goto cleanup;
		}
		else if( strcmp( argv[i], "-factor" ) == 0 )
		{
			ASSERT_ARGUMENT;
			sscanf( argv[++i], "%u", &factor );
			if( factor < 2 || factor > 8 )
			{
				fprintf( stderr, "Factor out of range: 2-8\n" );
				goto cleanup;
			}
		}
		else if( strcmp( argv[i], "-rotx" ) == 0 )
			rotate_model_x( model );
		else if( strcmp( argv[i], "-roty" ) == 0 )
			rotate_model_y( model );
		else if( strcmp( argv[i], "-rotz" ) == 0 )
			rotate_model_z( model );
		else if( strcmp( argv[i], "-flipx" ) == 0 )
			flip_model_x( model );
		else if( strcmp( argv[i], "-flipy" ) == 0 )
			flip_model_y( model );
		else if( strcmp( argv[i], "-flipz" ) == 0 )
			flip_model_z( model );
		else
		{
			fprintf( stderr, "Invalid parameter: %s\n", argv[i] );
			ret_code = 2;
			goto cleanup;
		}

	light_texture( &top_texture[0][0], 0.1 );
	light_texture( &right_texture[0][0], -0.1 );

	if( !(result = render_model( model, resolution * factor ) ) )
		goto cleanup;

	if( factor > 1 )
		downscale_image( result, resolution * factor, resolution * factor, factor );

	saveImage( argv[4], result, resolution, resolution );
	ret_code = 0;

cleanup:

	if( result )	free( result );
	free_model( model );

    return ret_code;
}
