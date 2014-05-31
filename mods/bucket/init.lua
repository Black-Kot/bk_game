function bk_game.register_bucket(name, def)

	minetest.register_craftitem(":bucket:"..name, {
		description = "Empty " .. def.description .. " Bucket",
		inventory_image = "bucket_"..name..".png",
		groups = {bucket_empty = 1},
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			local n = minetest.env:get_node(pointed_thing.under)
			local liquiddef = bk_game.registered_liquids[n.name]
			if not liquiddef then
				return
			end
			local full_name = empty_name.."_with_"..liquiddef.name
			if liquiddef and n.name == liquiddef.source and minetest.registered_items[full_name] then
				minetest.env:add_node(pointed_thing.under, {name="air"})
				return {name=full_name}
			end
		end,
	})


				minetest.register_craftitem(":bucket:"..name.."_with_water", {
					description = def.description .. " Bucket with Water",
					inventory_image = "bucket_"..name..".png^bucket_metal_water.png",
					groups = groups,
					stack_max = stack,
					liquids_pointable = true,
					on_use = function(itemstack, user, pointed_thing)
						-- "virtual" buckets
						if LiquidDef.source == "" then
							return
						end
						-- Must be pointing to node
						if pointed_thing.type ~= "node" then
							return
						end
						n = minetest.env:get_node(pointed_thing.under)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.under, {name=LiquidDef.source})
						else
							n = minetest.env:get_node(pointed_thing.above)
							if minetest.registered_nodes[n.name].buildable_to then
								minetest.env:add_node(pointed_thing.above, {name=LiquidDef.source})
							else
								return
							end
						end
						return {name=empty_name}
					end
				})

				if not def.not_lava then
								minetest.register_craftitem(":bucket:"..name.."_with_lava", {
					description = def.description .. " Bucket with lava",
					inventory_image = "bucket_"..name..".png^bucket_lava.png",
					groups = groups,
					stack_max = stack,
					liquids_pointable = true,
					on_use = function(itemstack, user, pointed_thing)
						-- "virtual" buckets
						if LiquidDef.source == "" then
							return
						end
						-- Must be pointing to node
						if pointed_thing.type ~= "node" then
							return
						end
						n = minetest.env:get_node(pointed_thing.under)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.under, {name=LiquidDef.source})
						else
							n = minetest.env:get_node(pointed_thing.above)
							if minetest.registered_nodes[n.name].buildable_to then
								minetest.env:add_node(pointed_thing.above, {name=LiquidDef.source})
							else
								return
							end
						end
						return {name=empty_name}
					end
				})
				end
		
	minetest.register_craft({
		output = "bucket:"..name,
		recipe = {
			{def.source, "", def.source},
			{def.source, "", def.source},
			{"", def.source, ""},
		},
	})

end

bk_game.register_bucket("wood", {
description = "Wood",
source = "group:plank",
not_lava = true,
})
