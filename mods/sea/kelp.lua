
function bk_game.register_kelp(name, def)

	minetest.register_node(":sea:kelp_"..name, {
		description = def.description.." Kelp",
		drawtype = "plantlike",
		tiles = {"sea_kelp_"..name..".png"},
		inventory_image = "sea_kelp_"..name..".png",
		wield_image = "sea_kelp_"..name..".png",
		paramtype = "light",
		walkable = false,
		climbable = true,
		is_ground_content = true,
		--[[
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3}
		},
		]]--
		post_effect_color = {a=64, r=100, g=100, b=200},
		groups = {snappy=3, kelp=1, sea=1},
		sounds = default.node_sound_leaves_defaults(),
		on_use = minetest.item_eat(1)
	})

	table.insert(registered_plants_list, "sea:kelp_"..name)

end

minetest.register_abm({
	nodenames = {"group:kelp"},
	interval = 6,
	chance = 3,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local name = minetest.get_node(pos).name
		local yp = {x = pos.x, y = pos.y + 1, z = pos.z}
		local yyp = {x = pos.x, y = pos.y + 2, z = pos.z}
		local yyyp = {x = pos.x, y = pos.y + 3, z = pos.z}
		if string.match(minetest.get_node(yp).name, "water") ~= nil  then
			if string.match(minetest.get_node(yp).name, "water") ~= nil  then
				if string.match(minetest.get_node(yp).name, "water") ~= nil then
					minetest.add_node(pos, {name = name})
					pos.y = pos.y + 1
					minetest.add_node(pos, {name = name})
				else
					return
				end
			end
		end
	end
})

local kelp_list = {
		["brown"] = {description="Brown"},
		["green"] = {description="Green"},
}

for kelp, desc in pairs(kelp_list) do
	bk_game.register_kelp(kelp, desc)
end
