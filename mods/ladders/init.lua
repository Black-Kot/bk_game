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
	if def.custom_description then
		def.description = def.custom_description
	else
		def.description = def.description.." Ladder"
	end
	minetest.register_node(":ladders:"..name, {
		description = def.description,
		drawtype = "nodebox",
		tiles = def.tiles,
		inventory_image = "ladders_"..name..".png",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		climbable = true,
		node_box = def.node_box,
		selection_box = def.node_box,
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
				end
				if param2 then
					minetest.set_node(pointed_thing.above,{name = "ladders:"..name, param2 = param2})
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
				end
				return itemstack
			end
		end,
		node_placement_prediction = "",
		groups = {snappy=5,choppy=5,oddly_breakable_by_hand=3,flammable=2},
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
	}
})
