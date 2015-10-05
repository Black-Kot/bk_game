function bk_game.register_slab(name, def)
	minetest.register_node(":blocks:"..name.."_slab",{
		description = def.description.." Slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		sunlight_propagates = def.sunlight_propagates,
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			-- If it"s being placed on an another similar one, replace it with
			-- a full block
			local slabpos = nil
			local slabnode = nil
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local n0 = minetest.get_node(p0)
			if n0.name == "blocks:"..name.."_slab" and
					p0.y+1 == p1.y then
				slabpos = p0
				slabnode = n0
			end

			if p0.y-1 == p1.y then
				-- Place upside down slab
				local fakestack = ItemStack("blocks:"..name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end

			-- If pointing at the side of a upside down slab
			if n0.name == "blocks:"..name.."_slab_upside_down" and
					p0.y+1 ~= p1.y then
				-- Place upside down slab
				local fakestack = ItemStack("blocks"..name.."_slab_upside_down")
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

	minetest.register_node(":blocks:"..name.."_slab_upside_down", {
		drop = "blocks:"..name.."_slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
		},
	})

	if not def.without_craft then
		minetest.register_craft({
			output = "blocks:"..name.."_slab 6",
			recipe = {
				{"blocks:"..name, "blocks:"..name, "blocks:"..name},
			},
		})

		minetest.register_craft({
			output = "blocks:"..name.." 2",
			recipe = {
				{"blocks:"..name.."_slab", "blocks:"..name.."_slab"},
				{"blocks:"..name.."_slab", "blocks:"..name.."_slab"},
			},
		})
	end
end
