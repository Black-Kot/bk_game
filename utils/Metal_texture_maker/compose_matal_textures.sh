#!/bin/bash

if [ $# != 5 ]; then
	echo "Usage: $0 <source_texture.png> <material_name> </dest/path/> <light_percent> <dark_percent>"
	exit 1
fi

script_dir=$(dirname "$BASH_SOURCE")

composite "$script_dir/block_dark_mask.png" -dissolve $5 "$1" "$script_dir/blocks.png"

convert "$1" "$script_dir/door_outer.png" -compose DstOut -alpha set -composite \
		"$script_dir/door_light_mask.png" -compose dissolve -define compose:args=$4 -composite \
		"$script_dir/door_dark_mask.png" -compose dissolve -define compose:args=$5 -composite \
		"$script_dir/door_artifacts.png" -compose Over -composite \
		"$script_dir/door.png"

convert "$1" "$script_dir/door_outer_a.png" -compose DstOut -alpha set -composite \
		"$script_dir/door_light_mask_a.png" -compose dissolve -define compose:args=$4 -composite \
		"$script_dir/door_dark_mask_a.png" -compose dissolve -define compose:args=$5 -composite \
		"$script_dir/door_artifacts_a.png" -compose Over -composite \
		"$script_dir/door_a.png"

convert "$1" "$script_dir/door_outer_b.png" -compose DstOut -alpha set -composite \
		"$script_dir/door_light_mask_b.png" -compose dissolve -define compose:args=$4 -composite \
		"$script_dir/door_dark_mask_b.png" -compose dissolve -define compose:args=$5 -composite \
		"$script_dir/door_artifacts_b.png" -compose Over -composite \
		"$script_dir/door_b.png"

pngcrush "$script_dir/blocks.png" "$3/blocks_${2}.png" > /dev/null
pngcrush "$script_dir/door.png" "$3/doors_${2}.png" > /dev/null
pngcrush "$script_dir/door_a.png" "$3/doors_${2}_a.png" > /dev/null
pngcrush "$script_dir/door_b.png" "$3/doors_${2}_b.png" > /dev/null

rm -f "$script_dir/blocks.png" "$script_dir/door.png" "$script_dir/door_a.png" "$script_dir/door_b.png"
