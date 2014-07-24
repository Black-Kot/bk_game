local directions = {
	{x = 1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = -1},
}

local function update_fence(pos)
	if minetest.get_node_group(minetest.get_node(pos).name, "fence") ~= 1 then
		return
	end
	local sum = 0
	for i = 1, 4 do
		local node = minetest.get_node({x = pos.x + directions[i].x, y = pos.y + directions[i].y, z = pos.z + directions[i].z})
		if minetest.registered_nodes[node.name].walkable ~= false then
			sum = sum + 2 ^ (i - 1)
		end
	end
	local name = minetest.get_node(pos).name:gsub("_%d+", "")
	minetest.add_node(pos, {name = name.."_"..sum})
end

local function update_nearby(pos)
	for i = 1,4 do
		update_fence({x = pos.x + directions[i].x, y = pos.y + directions[i].y, z = pos.z + directions[i].z})
	end
end

local blocks = {
	{{0, 0.25, -0.06, 0.5, 0.4, 0.06}, {0, -0.15, -0.06, 0.5, 0, 0.06}},
	{{-0.06, 0.25, 0, 0.06, 0.4, 0.5}, {-0.06, -0.15, 0, 0.06, 0, 0.5}},
	{{-0.5, 0.25, -0.06, 0, 0.4, 0.06}, {-0.5, -0.15, -0.06, 0, 0, 0.06}},
	{{-0.06, 0.25, -0.5, 0.06, 0.4, 0}, {-0.06, -0.15, -0.5, 0.06, 0, 0}}
}

local limiters = {
	{{0, 1.0, -0.1, 0.5, 1.0, -0.0999}, {0, 1.0, 0.0999, 0.5, 1.0, 0.1}},
	{{-0.1, 1.0, 0, -0.0999, 1.0, 0.5}, {0.0999, 1.0, 0, 0.1, 1.0, 0.5}},
	{{-0.5, 1.0, -0.1, 0, 1.0, -0.0999}, {-0.5, 1.0, 0.0999, 0, 1.0, 0.1}},
	{{-0.1, 1.0, -0.5, -0.0999, 1.0, 0}, {0.0999, 1.0, -0.5, 0.1, 1.0, 0}},
}

local base = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1}

function bk_game.register_fence(name, def)
	for i = 0, 15 do
		local take = {base}
		local take_with_limits = {base}
		for j = 1, 4 do
			if rshift(i, j - 1) % 2 == 1 then
				take = merge(take, blocks[j])
				take_with_limits = merge(take_with_limits, merge(blocks[j], limiters[j]))
			end
		end

		minetest.register_node(":fences:"..name.."_"..i, {
			drawtype = "nodebox",
			tiles = def.tiles,
			paramtype = "light",
			groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,drop_on_dig=1,fence=1},
			sunlight_propagates = true,
			drop = "fences:"..name,
			node_box = {
				type = "fixed",
				fixed = take_with_limits
			},
			selection_box = {
				type = "fixed",
				fixed = take
			},
			sounds = default.node_sound_wood_defaults(),
		})
	end

	minetest.register_node(":fences:"..name, {
		description = def.description.." Fence",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,drop_on_dig=1,fence=1},
		sunlight_propagates = true,
		node_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1}
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1}
		},
		on_construct = update_fence
	})

	minetest.register_craft({
		output = "fences:"..name.." 2",
		recipe = {
			{def.source, def.source, def.source},
			{def.source, def.source, def.source}
		}
	})
end

minetest.register_on_placenode(update_nearby)
minetest.register_on_dignode(update_nearby)
