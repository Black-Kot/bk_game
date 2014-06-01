local MAX_RATIO = 2000
local GROWING_DELAY = 3600

function is_node_in_cube(nodenames, node_pos, radius)
	for x = node_pos.x - radius, node_pos.x + radius do
		for y = node_pos.y - radius, node_pos.y + radius do
			for z = node_pos.z - radius, node_pos.z + radius do
				n = minetest.env:get_node_or_nil({x = x, y = y, z = z})
				if (n == nil)
					or (n.name == "ignore")
					or (nodenames == n.name) then
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

minetest.register_node("flowers:soil", {
	description = "Soil",
	tiles = {"flowers_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	is_ground_content = true,
	groups = {crumbly=5, not_in_creative_inventory=1, soil=1},
	sounds = default.node_sound_dirt_defaults(),
})



minetest.register_craft({
	output = "flowers:flower_pot",
	recipe = {
		{"clay_brick", "", "clay_brick" },
		{"", "clay_brick", ""},
	}
})

function bk_game.register_flower(name, def)

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
		groups = {snappy=6,oddly_breakable_by_hand=2,flower=1,flora=1,attached_node=1,color_white=1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},
		drop = {
			max_items = 1,
			items = {
				{items = {"flowers:"..name.."_seed 5"},rarity = 5},
				{items = {"flowers:"..name}},
			}
		},
	})

	if def.seed ~= false then

		minetest.register_node(":flowers:"..name.."_grass", {
			description = def.description.." Grass",
			drawtype = "plantlike",
			tiles = {"flowers_grass.png"},
			inventory_image = "flowers_grass.png",
			wield_image = "flowers_grass.png",
			paramtype = "light",
			waving = 1,
			walkable = false,
			buildable_to = true,
			is_ground_content = true,
			drop = "flowers:"..name.."_seed",
			groups = {snappy=6,oddly_breakable_by_hand=2,flora=1,grass=1,attached_node=1,not_in_creative_inventory=1},
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
		})
	
		minetest.register_craftitem(":flowers:"..name.."_seed", {
			description = def.description.." Seed",
			inventory_image = "flowers_seed.png",
			on_place  = function(itemstack, placer, pointed_thing)
				-- check if pointing at a node
				if pointed_thing.type ~= "node" then
					return
				end

				local under = minetest.get_node(pointed_thing.under)
				local above = minetest.get_node(pointed_thing.above)

				-- return if any of the nodes is not registered
				if not minetest.registered_nodes[under.name] then
					return
				end
				if not minetest.registered_nodes[above.name] then
					return
				end

				-- check if pointing at the top of the node
				if pointed_thing.above.y ~= pointed_thing.under.y+1 then
					return
				end

				-- check if you can replace the node above the pointed node
				if not minetest.registered_nodes[above.name].buildable_to then
					return
				end

				-- check if pointing at soil
				if under.name ~= "flowers:soil" then
					return
				end

				-- add the node and remove 1 item from the itemstack
				minetest.add_node(pointed_thing.above, {name="flowers:"..name.."_grass"})
				if not minetest.setting_getbool("creative_mode") then
					itemstack:take_item()
				end
				return itemstack
			end,
		})

		minetest.register_abm({
			nodenames = {"flowers:"..name.."_grass"},
			interval = 1,
			chance = 20,
			action = function(pos, node, active_object_count, active_object_count_wider)
				local p_top = {
					x = pos.x,
					y = pos.y - 1,
					z = pos.z
				}
				if minetest.env:get_node(p_top).name ~= "flowers:soil" then
					return
				end
				minetest.env:add_node(pos, {name="flowers:"..name})
				minetest.env:add_node(p_top, {name="default:dirt_with_grass"})
			end
		})
		
	else
		minetest.register_alias("flowers:"..name.."_seed", "flowers:"..name)
	end

	if def.pot ~= false then
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
	end

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
				local flower_in_range = is_node_in_cube("flowers:"..name, p_top, def.spacing)
				if (n_top.name == "air") and (flower_in_range == false) then
					minetest.env:add_node(p_top, {name = "flowers:"..name})
				end
			end
		end
	})
	
end


flowers_list = {

["rose"] = {description = "Rose", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},

["dandelion_yellow"] = {description = "Dandelion Yellow", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},

["dandelion_white"] = {description = "Sandelion White", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},

["tulip"] = {description = "Tulip", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},

["viola"] = {description = "Viola", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}},

["waterlily"] = {description="Waterlily", interval=GROWING_DELAY*2, chance=30, spacing=15, nodenames={"default:water_source"}, seed=false, pot=false},

}

for metal, descr in pairs(flowers_list) do
    bk_game.register_flower(metal, descr)
end
