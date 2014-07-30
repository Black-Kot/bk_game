-- From Moon Flower mod by MirceaKitsune

local GROWING_DELAY = 3600

bk_game.register_flower("moon_closed", { description = "Moon flower", interval=GROWING_DELAY*2, chance = 20, spacing = 15, nodenames={"default:dirt_with_grass"}, pot=false})
bk_game.register_flower("moon_open", { description = "Moon flower", light_source=10, pot=false, seed=false, generate=false})

minetest.register_abm({
	nodenames = { "flowers:moon_closed", "flowers:moon_open" },
	interval = 20,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local now = minetest.get_timeofday() * 24000
		if now < 5000 or now > 20000 then
			minetest.add_node(pos, { name = "flowers:moon_open" })
		else
			minetest.add_node(pos, { name = "flowers:moon_closed" })
		end
	end
})
