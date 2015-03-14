bk_game.slope_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5, 0, 0.5},
		{-0.5, 0, 0, 0.5, 0.25, 0.5},
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}
	}
}

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
