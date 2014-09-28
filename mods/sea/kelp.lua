
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
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local name=minetest.get_node(pos).name
		local height=0
		pos.y=pos.y-1
		if table.contains({"default:dirt", "default:sand", "default:peat"},
			minetest.get_node(pos).name) then
			pos.y=pos.y+1
			while minetest.get_node(pos).name==name and height < 3 do
				height=height+1
				pos.y=pos.y+1
			end
			if height < 3 then
				local nn=minetest.get_node(pos).name
				if string.match(nn,"water") then
					minetest.set_node(pos,{name=name})
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
