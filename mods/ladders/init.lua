function bk_game.register_ladder(name, def)
	if not def.node_box then
		-- Use ladder node_box
		def.node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.5-1/7, -0.5+1/7, 0.5, 0.5},
				{0.5-1/7, -0.5, 0.5-1/7, 0.5, 0.5, 0.5},
				{-0.5+1/7, 0.5-1/6-1/12, 0.5-1/16, 0.5-1/7, 0.5-1/12, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*3, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*2, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*5, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*4, 0.5},
			},
		}
	end
	description = nil
	if def.custom_description then
		description = def.custom_description
	else
		description = def.description.." Ladder"
	end

	if def.on_place then
		on_place = def.on_place
	else
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type == "node" and
				minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to == true then
				local param2 = nil
				if pointed_thing.above.x < pointed_thing.under.x then
					param2 = 1
				elseif pointed_thing.above.x > pointed_thing.under.x then
					param2 = 3
				elseif pointed_thing.above.z < pointed_thing.under.z then
					param2 = 0
				elseif pointed_thing.above.z > pointed_thing.under.z then
					param2 = 2
				else
					param2 = minetest.get_node(pointed_thing.under).param2
				end
				if param2 then
					minetest.set_node(pointed_thing.above,{name = "ladders:"..name, param2 = param2})
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
				end
				return itemstack
			end
		end
	end
	minetest.register_node(":ladders:"..name, {
		description = description,
		drawtype = "nodebox",
		tiles = def.tiles,
		inventory_image = "ladders_"..name..".png",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		climbable = true,
		node_box = def.node_box,
		selection_box = def.node_box,
		on_place = on_place,
		sunlight_propagates = true,
		node_placement_prediction = "",
		groups = {snappy=5,choppy=5,oddly_breakable_by_hand=3,flammable=2,ladder=1},
		sounds = default.node_sound_wood_defaults(),
	})

	if not def.ladders_from_source then
		craft_count = ""
	else
		craft_count = " "..def.ladders_from_source
	end
	if def.custom_craft then
		minetest.register_craft(def.custom_craft)
	else
		minetest.register_craft({
			output = "ladders:"..name..craft_count,
			recipe = {
				{def.source, "", def.source},
				{def.source, def.source, def.source},
				{def.source, "", def.source},
			}
		})
	end
end
-- Rope
bk_game.register_ladder("rope", {
	custom_description = "Rope",
	tiles = {"ladders_rope_tile.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{0.0-1/16, -0.5, 0.5-1/8, 0.0+1/16, 0.5, 0.5}
		}
	},
	custom_craft = {
		output = "ladders:rope 6",
		recipe = {
			{"cotton:cotton"},
			{"cotton:cotton"}
		}
	},
	on_place = function(itemstack, placer, pointed_thing)
		under = minetest.get_node(pointed_thing.under)
		above = minetest.get_node(pointed_thing.above)
			if pointed_thing.type == "node" and
				minetest.registered_nodes[above.name].buildable_to == true then
				local up = false
				local param2 = nil
				if under.name ~= "ladders:rope" then
					if pointed_thing.above.x < pointed_thing.under.x then
						param2 = 1
					elseif pointed_thing.above.x > pointed_thing.under.x then
						param2 = 3
					elseif pointed_thing.above.z < pointed_thing.under.z then
						param2 = 0
					elseif pointed_thing.above.z > pointed_thing.under.z then
						param2 = 2
					end
				else
					if pointed_thing.above.y < pointed_thing.under.y then
						up = false
					else
						up = true
					end
				end
				if param2 then
					minetest.set_node(pointed_thing.above,{name = "ladders:rope", param2 = param2})
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
				elseif up then
					
					if not minetest.setting_getbool("creative_mode") then
						pos = {x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}
						if minetest.get_node(pos).name == "air" then
							minetest.set_node(pos, {name = "ladders:rope", param2 = under.param2})
							itemstack:take_item()
						end
					end
				else
					minetest.set_node({x=pointed_thing.under.x, y=pointed_thing.under.y-1, z=pointed_thing.under.z},
						{name = "ladders:rope", param2 = under.param2})
				end
				return itemstack
			end
	end
})
