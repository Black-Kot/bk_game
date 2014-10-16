-- colored glass

-- for panes

local function rshift(x, by)
	return math.floor(x / 2 ^ by)
end

local directions = {
	{x = 1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = -1},
}

local function update_pane(pos)
	local _name = minetest.get_node(pos).name
	if string.match(_name, "glass:pane_") == nil then return end
	local lenght = string.len(_name)
	local __name = _name:reverse()
	local underscore_pos = __name:find("_", 1) or 0
	local name = _name
	if tonumber(__name:sub(1, underscore_pos - 1)) ~= nil then
		underscore_pos = lenght - underscore_pos
		name = _name:sub(1, underscore_pos)
	end
	local sum = 0
	for i, dir in pairs(directions) do
		local node = minetest.get_node({
			x = pos.x + dir.x,
			y = pos.y + dir.y,
			z = pos.z + dir.z
		})
		local def = minetest.registered_nodes[node.name]
		local pane_num = def and def.groups.pane or 0
		if pane_num > 0 or not def or (def.walkable ~= false and
				def.drawtype ~= "nodebox") then
			sum = sum + 2 ^ (i - 1)
		end
	end
	if sum == 0 then
		sum = 15
	end
	minetest.set_node(pos, {name = name.."_"..sum})
end

local function update_nearby(pos, node)
	for i, dir in pairs(directions) do
		update_pane({
			x = pos.x + dir.x,
			y = pos.y + dir.y,
			z = pos.z + dir.z
		})
	end
end

local half_boxes = {
	{0,     -0.5, -1/32, 0.5,  0.5, 1/32},
	{-1/32, -0.5, 0,     1/32, 0.5, 0.5},
	{-0.5,  -0.5, -1/32, 0,    0.5, 1/32},
	{-1/32, -0.5, -0.5,  1/32, 0.5, 0}
}

local full_boxes = {
	{-0.5,  -0.5, -1/32, 0.5,  0.5, 1/32},
	{-1/32, -0.5, -0.5,  1/32, 0.5, 0.5}
}

local sb_half_boxes = {
	{0,     -0.5, -0.06, 0.5,  0.5, 0.06},
	{-0.06, -0.5, 0,     0.06, 0.5, 0.5},
	{-0.5,  -0.5, -0.06, 0,    0.5, 0.06},
	{-0.06, -0.5, -0.5,  0.06, 0.5, 0}
}

local sb_full_boxes = {
	{-0.5,  -0.5, -0.06, 0.5,  0.5, 0.06},
	{-0.06, -0.5, -0.5,  0.06, 0.5, 0.5}
}

minetest.register_on_placenode(update_nearby)
minetest.register_on_dignode(update_nearby)


-- glass

for _, row in ipairs(bk_game.colors) do
	local name = row[1]
	local desc = row[2]
	local craft_color_group = row[3]
	-- Node Definition

	bk_game.register_nodes("glass_"..name, {
		stair = true,
		slab = true,
		description = desc.." Glass",
		tiles = {"glass_"..name..".png"},
        inventory_image = minetest.inventorycube("glass_"..name..".png"),
		drawtype = "glasslike",
		paramtype = "light",
		sunlight_propagates = true,
		groups = {cracky=6,oddly_breakable_by_hand=3,glass=1},
		sounds = default.node_sound_glass_defaults(),
	})

	if craft_color_group then
		-- Crafting from dye and white glass
		minetest.register_craft({
			type = "shapeless",
			output = "blocks:glass_"..name,
			recipe = {"dye:"..name, "group:glass"},
		})
	end

	-- panes
	textures = {"glass_"..name..".png", "glass_"..name..".png", "glass_"..name..".png"}
	inventory_image = ""
	for i = 1, 15 do
		local need = {}
		local cnt = 0
		for j = 1, 4 do
			if rshift(i, j - 1) % 2 == 1 then
				need[j] = true
				cnt = cnt + 1
			end
		end
		local take = {}
		local take2 = {}
		if need[1] == true and need[3] == true then
			need[1] = nil
			need[3] = nil
			table.insert(take, full_boxes[1])
			table.insert(take2, sb_full_boxes[1])
		end
		if need[2] == true and need[4] == true then
			need[2] = nil
			need[4] = nil
			table.insert(take, full_boxes[2])
			table.insert(take2, sb_full_boxes[2])
		end
		for k in pairs(need) do
			table.insert(take, half_boxes[k])
			table.insert(take2, sb_half_boxes[k])
		end
		local texture = textures[1]
		if cnt == 1 then
			texture = textures[1].."^"..textures[2]
		end
		if i == 1 then
			inventory_image = textures[3]
		end
		minetest.register_node("glass:pane_"..name.."_"..i, {
			drawtype = "nodebox",
			tiles = {textures[3], textures[3], texture},
			paramtype = "light",
			drop = "glass:pane_"..name,
			sounds = default.node_sound_glass_defaults(),
			groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3, pane=1},
			node_box = {
				type = "fixed",
				fixed = take
			},
			selection_box = {
				type = "fixed",
				fixed = take2
			}
		})
	end

	minetest.register_node("glass:pane_"..name, {
			description = desc.." Glass Pane",
			tiles = {"glass_"..name..".png"},
			inventory_image = "glass_"..name..".png",
			wield_image = "glass_"..name..".png",
			drawtype = "airlike",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			pointable = false,
			diggable = false,
			buildable_to = true,
			air_equivalent = true,
			sounds = default.node_sound_glass_defaults(),
			groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3, pane=1},
			on_construct = function(pos)
				update_pane(pos)
			end,
	})

	minetest.register_craft({
		output = "glass:pane_"..name.." 24",
		recipe = {
			{"blocks:glass_"..name, "blocks:glass_"..name, "blocks:glass_"..name},
			{"blocks:glass_"..name,"blocks:glass_"..name, "blocks:glass_"..name}
		}
	})

	minetest.register_craft({
		output = "blocks:glass_"..name.." 4",
		recipe = {
			{"glass:pane_"..name, "glass:pane_"..name},
			{"glass:pane_"..name,"glass:pane_"..name}
		}
	})

end
