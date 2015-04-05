bk_game.groups = {
	-- From default/nodes.lua
	stone		= {cracky=5, stone=1}, -- stone and desert stone
	dirt		= {crumbly=6, soil=1},
	sand		= {crumbly=6, falling_node=1, sand=1},
	gravel		= {crumbly=5, falling_node=1},
	sandstone	= {crumbly=4, cracky=4},
	clay		= {crumbly=6},
	brick		= {cracky=4},
	cactus		= {snappy=4, choppy=1, flammable=2, dropping_node=1, drop_on_dig=1, flower=1, color_green=1},
	papyrus		= {snappy=6, oddly_breakable_by_hand=2, flammable=2},
	dry_shrub	= {snappy=3,flammable=3,attached_node=1},
	sign		= {choppy=2,dig_immediate=2,attached_node=1},
	water		= {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, freezes=1, melt_around=1},
	water_source	= {water=3, liquid=3, puts_out_fire=1, freezes=1},
	lava		= {lava=3, liquid=2, hot=3, igniter=1, not_in_creative_inventory=1},
	lava_source	= {lava=3, liquid=2, hot=3, igniter=1},
	torch		= {choppy=7,dig_immediate=3,flammable=1,attached_node=1,hot=2,wield_light=LIGHT_MAX},
	scaffolding	= {scaffolding=1,dig_immediate=3,flammable=3},
	furnace		= {cracky=6},
	furnace_active	= {cracky=2, not_in_creative_inventory=1,hot=1},
	cobble		= {cracky=5, stone=2}, -- cobble, desert cobble and mossy cobble
	obsidian	= {cracky=4,level=2},
	nc		= {cracky=6}, -- Nyan Cat and Nyan Cat rainbow
}
