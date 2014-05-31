***** Isometry Renderer - render image from minetest model and texture *****

This program is useful to generate pictures for minetest wiki.
It renders in-game blocks, plants, tools and other crafts in isometry, similar to view in minetest's inventory.



Programs needed to build: gcc, libpng (+headers)



Command syntax:
	isometry_renderer <minetest.model> <texture.png> <resolution> <output.png> [parameters]

Arguments description
	1) Model is a minetest-style 3d model. Set of basic models is attached
	2) Texture as a second parameter is a main texture. It will be applied on the top surfaces anyway, and on left and right surfaces if another textures are not specified.
	3) resolution is an output image dimensions. Square image resolution*resolution will be produced.
	4) Name of output file. PNG format is only supported.
	5) Optional parameters:
		a) -left-tex <texture.png> - override a main texture on left side surfaces
		b) -right-tex <texture.png> - override a main texture on right side surfaces
		c) -factor <x> - render x times larger image, then downscale them x times. It can be used to smooth output, because the "nearest" texture filter is used during render.
		d) Transformate model before texture application and render:
			-rotx, -roty, -rotz - rotate image along axis clockwise
			-flipx, -flipy, -flipz - flip image along axis
			X axis is dircted left, Y - right and Z - top.
