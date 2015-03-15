
bk_game.registered_mushrooms_list = {}

function bk_game.register_mushroom(name, def)

	if def.groups == nil then
		def.groups = {}
	end
	
	def.groups.snappy=6
	def.groups.oddly_breakable_by_hand=3
	def.groups.mushroom=1
	def.groups.flora=1
	def.groups.attached_node=1

	minetest.register_node(":mushrooms:"..name, {
		description = def.description,
		drawtype = def.drawtype or "plantlike",
		tiles = { "mushrooms_"..name..".png" },
		inventory_image = "mushrooms_"..name..".png",
		wield_image = "mushrooms_"..name..".png",
		sunlight_propagates = true,
		paramtype = "light",
		light_source = def.light_source or 12,
		walkable = false,
		buildable_to = true,
		groups = def.groups,
		sounds = default.node_sound_leaves_defaults(),
		drop = def.drop or "mushrooms:"..name,
	})

	minetest.register_node(":mushrooms:"..name.."_grass", {
		description = def.description.." Grass",
		drawtype = "plantlike",
		tiles = {"mushrooms_grass.png"},
		inventory_image = "mushrooms_grass.png",
		wield_image = "mushrooms_grass.png",
		paramtype = "light",
		waving = 1,
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		drop = "mushrooms:"..name.."_seed",
		groups = def.groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})

	minetest.register_craftitem(":mushrooms:"..name.."_seed", {
		description = def.description.." Seed",
		inventory_image = "mushrooms_seed.png",
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
			minetest.add_node(pointed_thing.above, {name="mushrooms:"..name.."_grass"})
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	minetest.register_craft({
		output = "mushrooms:"..name.."_seed 3",
		recipe = {{"mushrooms:"..name}},
	})

	minetest.register_abm({
		nodenames = {"mushrooms:"..name.."_grass"},
		interval = 5,
		chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {
				x = pos.x,
				y = pos.y - 1,
				z = pos.z
			}
			if minetest.add_node(p_top).name ~= "flowers:soil" then
				return
			end
			minetest.add_node(pos, {name="mushrooms:"..name})
			minetest.add_node(p_top, {name="default:dirt_with_grass"})
		end
	})

	local mushroom = {
		name = "mushrooms:"..name,
		chance = def.chance,
		wherein = def.wherein,
	}
	table.insert(bk_game.registered_mushrooms_list, mushroom)

end

local function generate(mushroom, minp, maxp, pr)
	local pos = { x=pr:next(minp.x, maxp.x),y=pr:next(minp.y, maxp.y), z=pr:next(minp.z, maxp.z) }
	while pos.y > minp.y do
		pos.y = pos.y - 1
		if table.contains(mushroom.wherein, minetest.get_node(pos).name) then
			local pos2 = {x=pos.x, y=pos.y-1, z=pos.z}
			local under = minetest.get_node(pos2).name
			if minetest.registered_nodes[under].drawtype == "normal" then
				minetest.add_node(pos, {name=mushroom.name})
				return
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y > -100 then
		return
	end
	local pr = PseudoRandom(seed)
	local n = pr:next(1, maxp.x - minp.x)
	pr = PseudoRandom(seed + n)
	for i = 1, n do
		for _, mushroom in ipairs(bk_game.registered_mushrooms_list) do
			generate(mushroom, minp, maxp, pr)
		end
	end
end)

mushrooms_list = {
	green = {
		description = "Green Mushroom",
		wherein = {"air"},
		chance = 20
	},
	red = {
		description="Red Mushroom",
		wherein = {"air"},
		chance = 20
	},
	brown = {
		description="Brown Mushroom",
		wherein = {"air"},
		chance = 20
	}
}

for mushroom, def in pairs(mushrooms_list) do
    bk_game.register_mushroom(mushroom, def)
end

