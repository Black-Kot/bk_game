bk_game.groups = {
	-- From default/nodes.lua
	stone		= {cracky=3, stone=1}, -- stone and desert stone
	dirt		= {crumbly=3, soil=1},
	sand		= {crumbly=3, falling_node=1, sand=1},
	gravel		= {crumbly=2, falling_node=1},
	sandstone	= {crumbly=2, cracky=4},
	clay		= {crumbly=3},
	brick		= {cracky=2},
	cactus		= {snappy=2, choppy=1, flammable=2, dropping_node=1, drop_on_dig=1, flower=1, color_green=1},
	papyrus		= {snappy=3, oddly_breakable_by_hand=3, flammable=2},
	dry_shrub	= {snappy=3, oddly_breakable_by_hand=3, flammable=3,attached_node=1},
	sign		= {choppy=3,dig_immediate=2,attached_node=1},
	water		= {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, freezes=1, melt_around=1},
	water_source	= {water=3, liquid=3, puts_out_fire=1, freezes=1},
	lava		= {lava=3, liquid=2, hot=3, igniter=1, not_in_creative_inventory=1},
	lava_source	= {lava=3, liquid=2, hot=3, igniter=1},
	torch		= {dig_immediate=3,flammable=1,attached_node=1,hot=2,wield_light=LIGHT_MAX},
	scaffolding	= {scaffolding=1,dig_immediate=3,flammable=3},
	furnace		= {cracky=3},
	furnace_active	= {cracky=3, not_in_creative_inventory=1,hot=1},
	cobble		= {cracky=3, stone=2}, -- cobble, desert cobble and mossy cobble
	obsidian	= {cracky=1, level=3},
	nc		= {cracky=3}, -- Nyan Cat and Nyan Cat rainbow
	-- metals/init.lua
	adamant		= {cracky=1, level=3},
	mithril		= {cracky=1, level=3},
	titan		= {cracky=1, level=3},
	steel		= {cracky=1, level=2},
	gold		= {cracky=2, level=2},
	silver		= {cracky=2, level=2},
	zinc		= {cracky=2, level=2},
	aluminium	= {cracky=2, level=2},
	copper		= {cracky=1, level=1},
	bronze		= {cracky=1, level=1},
	brass		= {cracky=1, level=1},
	black_gold	= {cracky=2, level=2},
	green_gold	= {cracky=2, level=2},
	violet_gold	= {cracky=2, level=2},
	rose_gold	= {cracky=2, level=2},
	-- trees/registration.lua
	trunk		= {tree=1,choppy=3,snappy=3,flammable=2},
	planks		= {planks=1,snappy=3,choppy=3,oddly_breakable_by_hand=2,flammable=3},
}
