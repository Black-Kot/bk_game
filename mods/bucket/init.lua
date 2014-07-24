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
			local n = minetest.get_node(pointed_thing.under)
			local t = ""
			if n.name == "default:lava_source" then
				t = "lava"
			elseif n.name == "default:water_source" then
				t = "water"
			elseif n.name == "default:oil_source" then
				t = "oil"
			else
				return
			end
			local full_name = "bucket:"..name.."_with_"..t
			if minetest.registered_items[full_name] then
				minetest.add_node(pointed_thing.under, {name="air"})
				return {name=full_name}
			end
		end
	})
	
	minetest.register_craftitem(":bucket:"..name.."_with_water", {
		description = def.description .. " Bucket with Water",
		inventory_image = "bucket_"..name..".png^bucket_metal_water.png",
		groups = {bucket_water = 1},
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			-- "virtual" buckets
			if "default:water_source" == "" then
				return
			end
			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end
			n = minetest.get_node(pointed_thing.under)
			if minetest.registered_nodes[n.name].buildable_to then
				minetest.add_node(pointed_thing.under, {name="default:water_source"})
			else
				n = minetest.get_node(pointed_thing.above)
			if minetest.registered_nodes[n.name].buildable_to then
					minetest.add_node(pointed_thing.above, {name="default:water_source"})
				else
					return
				end
			end
			return {name="bucket:"..name}
		end
	})

	
	minetest.register_craftitem(":bucket:"..name.."_with_oil", {
		description = def.description .. " Bucket with Oil",
		inventory_image = "bucket_"..name..".png^bucket_metal_oil.png",
		groups = {bucket_water = 1},
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			-- "virtual" buckets
			if "default:oil_source" == "" then
				return
			end
			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end
			n = minetest.get_node(pointed_thing.under)
			if minetest.registered_nodes[n.name].buildable_to then
				minetest.add_node(pointed_thing.under, {name="default:oil_source"})
			else
				n = minetest.get_node(pointed_thing.above)
			if minetest.registered_nodes[n.name].buildable_to then
					minetest.add_node(pointed_thing.above, {name="default:oil_source"})
				else
					return
				end
			end
			return {name="bucket:"..name}
		end
	})

				if not def.not_lava then
					minetest.register_craftitem(":bucket:"..name.."_with_lava", {
					description = def.description .. " Bucket with lava",
					inventory_image = "bucket_"..name..".png^bucket_lava.png",
					groups = {bucket_lava = 1},
					stack_max = 1,
					liquids_pointable = true,
					on_use = function(itemstack, user, pointed_thing)
						-- "virtual" buckets
						if "default:lava_source" == "" then
							return
						end
						-- Must be pointing to node
						if pointed_thing.type ~= "node" then
							return
						end
						n = minetest.get_node(pointed_thing.under)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.add_node(pointed_thing.under, {name="default:lava_source"})
						else
							n = minetest.get_node(pointed_thing.above)
							if minetest.registered_nodes[n.name].buildable_to then
								minetest.add_node(pointed_thing.above, {name="default:lava_source"})
							else
								return
							end
						end
						return {name="bucket:"..name}
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
description = "Wooden",
source = "group:wood",
not_lava = true,
})
