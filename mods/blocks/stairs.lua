bk_game.slope_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5, 0, 0.5},
		{-0.5, 0, 0, 0.5, 0.25, 0.5},
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}
	}
}

function stair(node)
	return string.find(node.name, "_stair") ~= nil
end

function bk_game.register_stair(name, def)
	local name = name:remove_modname_prefix()
	minetest.register_node(":blocks:"..name.."_stair", {
		description = def.description.." Stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above

			local north = minetest.get_node({x = p1.x, y = p1.y, z = p1.z + 1})
			local south = minetest.get_node({x = p1.x, y = p1.y, z = p1.z - 1})
			local west =  minetest.get_node({x = p1.x - 1, y = p1.y, z = p1.z})
			local east =  minetest.get_node({x = p1.x + 1, y = p1.y, z = p1.z})

			local ne = minetest.get_node({x = p1.x + 1, y = p1.y, z = p1.z + 1})
			local nw = minetest.get_node({x = p1.x - 1, y = p1.y, z = p1.z + 1})
			local se = minetest.get_node({x = p1.x + 1, y = p1.y, z = p1.z - 1})
			local sw = minetest.get_node({x = p1.x - 1, y = p1.y, z = p1.z - 1})

			local pp = placer:getpos()

			local facedir = minetest.dir_to_facedir({x=p1.x-pp.x, y = 0, z=p1.z-pp.z})

			--[[
			          +Z
			   +----+----+----+
			   | NW | N  | NE |
			   +----+----+----+
			-X | W  | p1 | E  | +X
			   +----+----+----+
			   | SW | S  | SE |
			   +----+----+----+
			          -Z
			--]]

			-- FIXME: too slow
			if facedir == 0 then -- NORTH
				if stair(east) then
					if stair(ne) and ne.param2 % 32 == 3 then
						minetest.set_node({x = p1.x + 1, y = p1.y, z = p1.z}, {name = east.name .. "_corner", param2 = 0})
					elseif stair(se) and se.param2 % 32 == 1 then
						minetest.set_node({x = p1.x + 1, y = p1.y, z = p1.z}, {name = east.name .. "_inner", param2 = 1})
					end
				end
				if stair(west) then
					if stair(nw) and nw.param2 % 32 == 1 then
						minetest.set_node({x = p1.x - 1, y = p1.y, z = p1.z}, {name = west.name .. "_corner", param2 = 1})
					elseif stair(sw) and sw.param2 % 32 == 3 then
						minetest.set_node({x = p1.x - 1, y = p1.y, z = p1.z}, {name = west.name .. "_inner", param2 = 0})
					end
				end
			elseif facedir == 1 then -- EAST
				if stair(north) then
					if stair(ne) and ne.param2 % 32 == 2 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z + 1}, {name = north.name .. "_corner", param2 = 2})
					elseif stair(nw) and nw.param2 % 32 == 0 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z + 1}, {name = north.name .. "_inner", param2 = 1})
					end
				end
				if stair(south) then
					if stair(se) and se.param2 % 32 == 0 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z - 1}, {name = south.name .. "_corner", param2 = 1})
					elseif stair(sw) and sw.param2 % 32 == 2 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z - 1}, {name = south.name .. "_inner", param2 = 2})
					end
				end
			elseif facedir == 2 then -- SOUTH
				if stair(east) then
					if stair(se) and se.param2 % 32 == 3 then
						minetest.set_node({x = p1.x + 1, y = p1.y, z = p1.z}, {name = east.name .. "_corner", param2 = 3})
					elseif stair(ne) and ne.param2 % 32 == 1 then
						minetest.set_node({x = p1.x + 1, y = p1.y, z = p1.z}, {name = east.name .. "_inner", param2 = 2})
					end
				end
				if stair(west) then
					if stair(sw) and sw.param2 % 32 == 1 then
						minetest.set_node({x = p1.x - 1, y = p1.y, z = p1.z}, {name = west.name .. "_corner", param2 = 2})
					elseif stair(nw) and nw.param2 % 32 == 3 then
						minetest.set_node({x = p1.x - 1, y = p1.y, z = p1.z}, {name = west.name .. "_inner", param2 = 3})
					end
				end
			elseif facedir == 3 then -- WEST
				if stair(north) then
					if stair(nw) and nw.param2 % 32 == 2 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z + 1}, {name = north.name .. "_corner", param2 = 3})
					elseif stair(ne) and ne.param2 % 32 == 0 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z + 1}, {name = north.name .. "_inner", param2 = 0})
					end
				end
				if stair(south) then
					if stair(sw) and sw.param2 % 32 == 0 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z - 1}, {name = south.name .. "_corner", param2 = 0})
					elseif stair(se) and se.param2 % 32 == 2 then
						minetest.set_node({x = p1.x, y = p1.y, z = p1.z - 1}, {name = south.name .. "_inner", param2 = 3})
					end
				end
			end

			if p0.y-1 == p1.y then
				local fakestack = ItemStack("blocks:"..name.."_stair_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end

			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})

	minetest.register_node(":blocks:"..name.."_stair_corner", {
		drop = "blocks:"..name.."_stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.0, 0.5, 0.5},
			},
		},

	})

	minetest.register_node(":blocks:"..name.."_stair_inner", {
		drop = "blocks:"..name.."_stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0.5}
			},
		},

	})

	minetest.register_node(":blocks:"..name.."_stair_upside_down", {
		drop = "blocks:"..name.."_stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, 0, 0.5, 0, 0.5},
			},
		},
	})


	if not def.without_craft == true then
		minetest.register_craft({
			output = "blocks:"..name.."_stair 8",
			recipe = {
				{"blocks:"..name, "", ""},
				{"blocks:"..name, "blocks:"..name, ""},
				{"blocks:"..name, "blocks:"..name, "blocks:"..name},
			},
		})

		-- Flipped recipe for the silly minecrafters
		minetest.register_craft({
			output = "blocks:"..name.."_stair 8",
			recipe = {
				{"", "", "blocks:"..name},
				{"", "blocks:"..name, "blocks:"..name},
				{"blocks:"..name, "blocks:"..name, "blocks:"..name},
			},
		})

		minetest.register_craft({
			output = "blocks:"..name.." 3",
			recipe = {
				{"blocks:"..name.."_stair", "blocks:"..name.."_stair"},
				{"blocks:"..name.."_stair", "blocks:"..name.."_stair"},
			},
		})
	end
end

function bk_game.register_slope(name, def)
	local slope = "blocks:"..name.."_slope"
	minetest.register_node(":blocks:"..name.."_slope", {
		description = def.description.." Slope",
		drawtype = "mesh",
		mesh = "blocks_slope.obj",
		tiles = def.tiles,
		collision_box = bk_game.slope_box,
		selection_box = bk_game.slope_box,
		groups = def.groups,
		sounds = def.sounds,
		paramtype = "light",
		paramtype2 = "facedir",
		on_place = minetest.rotate_node,
		sunlight_propagates = true
	})
	minetest.register_craft({

		output = "blocks:"..name.."_slope 6",
		recipe = {
			{"blocks:"..name, "", ""},
			{"blocks:"..name, "blocks:"..name, ""},
			{"","",""}
		},
	})
	-- Reversed
	minetest.register_craft({
		output = "blocks:"..name.."_slope 6",
		recipe = {
			{"", "blocks:"..name,""},
			{"blocks:"..name, "blocks:"..name,""},
			{"","",""}
		},
	})

	minetest.register_craft({
		type = "shapeless",
		output = "blocks:"..name.." 3",
		recipe = {slope, slope, slope, slope, slope, slope}
	})
end
