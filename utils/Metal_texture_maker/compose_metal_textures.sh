#!/bin/bash

function makeTexture()
{
	convert "$1" \
			"$script_dir/masks/${2}_outer.png" -compose DstOut -alpha set -composite \
			"$script_dir/masks/${2}_light_mask.png" -compose dissolve -define compose:args=$3 -composite \
			"$script_dir/masks/${2}_dark_mask.png" -compose dissolve -define compose:args=$4 -composite \
			"$script_dir/masks/${2}_artifacts.png" -compose Over -composite \
			"$script_dir/${2}.png"
}


if [ $# -lt 5 ]; then
	echo "Usage: $0 <source_texture.png> <material_name> </dest/path/> <light_percent> <dark_percent> [notools]"
	exit 1
fi

script_dir=$(dirname "$BASH_SOURCE")

makeTexture "$1" block "$4" "$5"
makeTexture "$1" door "$4" "$5"
makeTexture "$1" door_a "$4" "$5"
makeTexture "$1" door_b "$4" "$5"

pngcrush "$script_dir/block.png" "${3}/blocks_${2}.png" > /dev/null
pngcrush "$script_dir/door.png" "${3}/doors_${2}.png" > /dev/null
pngcrush "$script_dir/door_a.png" "${3}/doors_${2}_a.png" > /dev/null
pngcrush "$script_dir/door_b.png" "${3}/doors_${2}_b.png" > /dev/null

if [ $# -lt 6 ] || [ "$6" != "notools" ]; then
	convert "$1" -scale 1x1\! -scale 16x16\! "$script_dir/pure.png"
	for tool in "axe" "bucket" "hoe" "pick" "shovel" "sword"; do
		makeTexture "$script_dir/pure.png" "$tool" "$4" "$5"
		pngcrush "$script_dir/${tool}.png" "${3}/tools_${tool}_${2}.png" > /dev/null
	done
fi

rm -f "$script_dir"/*.png
