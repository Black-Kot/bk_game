Making metal blocks and doors from metal master texture

Programs needed to run: imagemagick, pngcrush

Syntax:

compose_metal_textures.sh   source_texture.png    material_name   /dest/path/  <light_percent>   <dark_percent>		[notools]

It takes "source_texture.png" and write next files to /dest/path/ :
blocks_${material_name}.png
doors_${material_name}.png
doors_${material_name}_a.png
doors_${material_name}_b.png

If "notools" is not specified, next textures will be also produced:
tools_axe_${material_name}.png
tools_bucket_${material_name}.png
tools_hoe_${material_name}.png
tools_pick_${material_name}.png
tools_shovel_${material_name}.png
tools_sword_${material_name}.png

light_percent - multiplier for making light surfaces (0-99)
dark_percent  - multiplier for making dark surfaces (0-99)
