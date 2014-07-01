local MAX_RATIO = 2000
local GROWING_DELAY = 3600

bk_game.registered_flowers_list = {}

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

minetest.register_node("flowers:soil", {
	description = "Soil",
	tiles = {"flowers_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	is_ground_content = true,
	groups = {crumbly=5, not_in_creative_inventory=1, soil=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craftitem("flowers:pot", {
	description = "Pot",
	inventory_image = "flowers_pot.png",
})

minetest.register_craft({
	output = "flowers:flower_pot",
	recipe = {
		{"clay_brick", "", "clay_brick" },
		{"", "clay_brick", ""},
	}
})

function bk_game.register_flower(name, def)
	if def.groups == nil then
		def.groups = {}
	end
	
	def.groups.snappy=6
	def.groups.oddly_breakable_by_hand=3
	def.groups.flower=1
	def.groups.flora=1
	def.groups.attached_node=1

	minetest.register_node(":flowers:"..name, {
		description = def.description,
		drawtype = def.drawtype or "plantlike",
		tiles = { "flowers_"..name..".png" },
		inventory_image = "flowers_"..name..".png",
		wield_image = "flowers_"..name..".png",
		sunlight_propagates = true,
		paramtype = "light",
		light_source = def.light_source or nil,
		walkable = false,
		buildable_to = true,
		groups = def.groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},
		drop = def.drop or "flowers:"..name,
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
			groups = def.groups,
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

		minetest.register_craft({
			output = "flowers:"..name.."_seed 3",
			recipe = {{"flowers:"..name}},
		})

		minetest.register_abm({
			nodenames = {"flowers:"..name.."_grass"},
			interval = 5,
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

	if def.generate ~= false then
		flower = {
			name = "flowers:"..name,
			nodenames = def.nodenames,
			chance = def.chance,
		}
		table.insert(bk_game.registered_flowers_list, flower)
	end
end
			
flowers_list = {

["rose"] = {description = "Rose", interval=GROWING_DELAY*2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_red=1}},

["dandelion_yellow"] = {description = "Dandelion Yellow", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_yellow=1}},

["dandelion_white"] = {description = "Dandelion White", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_white=1}},

["tulip"] = {description = "Tulip", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_orange=1}},

["viola"] = {description = "Viola", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_violet=1}},

["geranium"] = {description = "Geranium", interval=GROWING_DELAY/2,chance = 4, spacing = 15, nodenames={"default:dirt_with_grass"}, groups={color_blue=1}},

["waterlily"] = {description="Waterlily", drawtype="raillike", interval=GROWING_DELAY*2, chance=10, spacing=15, nodenames={"default:water_source"}, seed=false, pot=false},

}

for metal, descr in pairs(flowers_list) do
    bk_game.register_flower(metal, descr)
end

local function generate(flower, minp, maxp, seed)
	local perlin1 = minetest.env:get_perlin(329, 3, 0.6, 100)
	local pr = PseudoRandom(seed)
	-- Assume X and Z lengths are equal
	local divlen = 16
	local divs = (maxp.x-minp.x)/divlen+1;
	for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine flower amount from perlin noise
			local flower_amount = math.floor(perlin1:get2d({x=x0, y=z0}) * 5 + 0)
			-- Find random positions for flower based on this random
			local pr = PseudoRandom(seed)
			for i=0,flower_amount do
				local x = pr:next(x0, x1)
				local z = pr:next(z0, z1)
				-- Find ground level (0...30)
				local ground_y = nil
				for y=30,0,-1 do
					if table.contains(flower.nodenames, minetest.env:get_node({x=x,y=y,z=z}).name) then
						ground_y = y
						break
					end
				end
				if ground_y then
					if pr:next(1, flower.chance) == flower.chance then
						minetest.env:add_node({x=x,y=ground_y+1,z=z}, {name = flower.name})
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	local n = pr:next(1,7)
	if pr:next(1,2) == 1 then
		n = n + 1
	end
	if pr:next(1, 10) == 1 then
		n = n + 1
	end
	if pr:next(1, 20) == 1 then
		n = n + 1
	end
	for i = 1, n do
		for _, flower in ipairs(bk_game.registered_flowers_list) do
			generate(flower, minp, maxp, seed + _ + n)
		end
	end
end)

dofile(minetest.get_modpath("flowers").."/moon.lua") -- Moon Flower
