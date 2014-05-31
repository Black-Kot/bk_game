local MAX_RATIO = 2000
local GROWING_DELAY = 3600

function is_node_in_cube(nodenames, node_pos, radius)
	for x = node_pos.x - radius, node_pos.x + radius do
		for y = node_pos.y - radius, node_pos.y + radius do
			for z = node_pos.z - radius, node_pos.z + radius do
				n = minetest.env:get_node_or_nil({x = x, y = y, z = z})
				if (n == nil)
					or (n.name == "ignore")
					or (table.contains(nodenames, n.name) == true) then
					return true
				end
			end
		end
	end

	return false
end

-- Items
minetest.register_craftitem("flowers:pot", {
	drawtype = "plantlike",
	image = "flower_pot.png",
	stack_max = 1,
	visual_scale = 1.0,
	sunlight_propagates = true,
	paramtype = "light",
	walkable = true,
	material = minetest.digprop_constanttime(0.5),
})

minetest.register_craft({
	output = "flowers:flower_pot",
	recipe = {
		{"clay_brick", "", "clay_brick" },
		{"", "clay_brick", ""},
	}
})

function bk_game.register_flower(name, def)

	minetest.register_craftitem(":flowers:"..name.."_seed", {
		description = def.description.." Seed",
		inventory_image = "flowers_"..name.."_seed.png",
	})
	
	minetest.register_node(":flowers:"..name, {
		description = def.description,
		drawtype = "plantlike",
		tiles = { "flowers_"..name..".png" },
		inventory_image = "flowers_"..name..".png",
		wield_image = "flowers_"..name..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		groups = {snappy=6,flower=1,flora=1,attached_node=1,color_white=1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},
		drop = {
			max_items = 1,
			items = {
				{
					items = {"flowers:"..name},
					rarity = 30,
				},
				{
					items = {"flowers:"..name.."_seed"},
					rarity = 10,
				}
			}
		},
	})

	minetest.register_craftitem(":flowers:"..name.."_pot", {
		drawtype = "plantlike",
		image = "flowers_"..name.."_pot.png",
		stack_max = 1,
		visual_scale = 1.2,
		sunlight_propagates = true,
		paramtype = "light",
		walkable = true,
		material = minetest.digprop_constanttime(1.0),
	})

	minetest.register_craft({
		output = "flowers:"..name.."_pot",
		recipe = {
			{"flowers:"..name},
			{"flowers:pot"},
		}
	})

	minetest.register_abm({
		nodenames = def.nodenames,
		interval = def.interval,
		chance = 30,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {
				x = pos.x,
				y = pos.y + 1,
				z = pos.z
			}
			local n_top = minetest.env:get_node(p_top)
			local rnd = math.random(1, MAX_RATIO)
			if (MAX_RATIO - def.chance < rnd) then
				local flower_in_range = is_node_in_cube({"flowers:"..name}, p_top, def.spacing)
				if (n_top.name == "air") and (flower_in_range == false) then
					minetest.env:add_node(p_top, {name = "flowers:"..name})
				end
			end
		end
	})
	
end


flowers_list = {
["rose"] = {description = "Rose", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},
["dandelion_yellow"] = {description = "Dandelion Yellow", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},
["dandelion_white"] = {description = "Sandelion White", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},
["tulip"] = {description = "Tulip", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},
["viola"] = {description = "Viola", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},
}

for metal, descr in pairs(flowers_list) do
    bk_game.register_flower(metal, descr)
end


--waterlily

minetest.register_node("flowers:waterlily", {
	drawtype = "raillike",
	tile_images = { "flower_waterlily.png", },
	inventory_image = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	walkable = false,
	material = minetest.digprop_constanttime(0.0),
})

minetest.register_abm({
	nodenames = {"default:water_source"},
	interval = 1800,
	chance = 30,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local p_top = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}
		local n_top = minetest.env:get_node(p_top)
		local rnd = math.random(1, MAX_RATIO)
		if (MAX_RATIO - 1 < rnd) then
			local flower_in_range = is_node_in_cube("flowers:waterlily", p_top, 15)
			if (n_top.name == "air") and (flower_in_range == false) then
				minetest.env:add_node(p_top, {name = "flowers:waterlily"})
			end
		end
	end
})
