core.register_biome({
	name           = "bk_normal",
	
	height_min     = 3,
	height_max     = 40,
	heat_point     = 20.0,
	humidity_point = 40.0,
})

core.register_biome({
	name           = "bk_ocean_with_sand",
	
	node_top       = "default:sand",
	depth_top      = 3,
	node_filler    = "blocks:stone",
	depth_filler   = 0,
	
	height_min     = -31000,
	height_max     = 2,
	heat_point     = 20.0,
	humidity_point = 60.0,
})

core.register_biome({
	name           = "bk_ocean_with_dirt",
	
	height_min     = -31000,
	height_max     = 2,
	heat_point     = 20.0,
	humidity_point = 60.0,
})

core.register_biome({
	name           = "bk_desert",
	
	node_top       = "default:desert_sand",
	depth_top      = 10,
	node_filler    = "blocks:desert_stone",
	
	height_min     = 3,
	height_max     = 300,
	heat_point     = 35.0,
	humidity_point = 0.0,
})
