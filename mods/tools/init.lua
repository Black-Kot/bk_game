dofile(minetest.get_modpath(minetest.get_current_modname()).."/groupcaps.lua")
function bk_game.register_pick(name, def)
	minetest.register_tool(":tools:pick_"..name, {
		description = def.description.." Pickaxe",
		inventory_image = "tools_pick_"..name..".png",
		tool_capabilities = {
			full_punch_interval = def.full_punch_interval,
			groupcaps = bk_game.groupcaps[name].pick,
		}
	})
	minetest.register_craft({
		output = "tools:pick_"..name,
		recipe = {
			{def.source, def.source, def.source},
			{"", "group:stick", ""},
			{"", "group:stick", ""},
		}
	})
end
function bk_game.register_shovel(name, def)
	minetest.register_tool(":tools:shovel_"..name, {
		description = def.description.." Shovel",
		inventory_image = "tools_shovel_"..name..".png",
		tool_capabilities = {
			full_punch_interval = 0.9,
			groupcaps = bk_game.groupcaps[name].shovel,
		},
	})
	minetest.register_craft({
		output = "tools:shovel_"..name,
		recipe ={
			{def.source},
			{"group:stick"},
			{"group:stick"},
		}
	})
end
function bk_game.register_axe(name, def)
	minetest.register_tool(":tools:axe_"..name, {
		description = def.description.." Axe",
		inventory_image = "tools_axe_"..name..".png",
		tool_capabilities = {
			full_punch_interval = 0.9,
			groupcaps = bk_game.groupcaps[name].axe,
		},
	})

	minetest.register_craft({
		output = "tools:axe_"..name,
		recipe = {
			{def.source, def.source},
			{def.source, "group:stick"},
			{"", "group:stick"},
		}
	})
	minetest.register_craft({
		output = "tools:axe_"..name,
		recipe = {
			{"", def.source, def.source},
			{"", "group:stick",  def.source},
			{"", "group:stick",  ""},
		}
	})
end
function bk_game.register_sword(name, def)
	minetest.register_tool(":tools:sword_"..name, {
		description = def.description.." Sword",
		inventory_image = "tools_sword_"..name..".png",
		tool_capabilities = {
			full_punch_interval = 0.9,
			groupcaps = bk_game.groupcaps[name].sword,
		},
	})
	minetest.register_craft({
		output = "tools:sword_"..name,
		recipe = {
			{def.source},
			{def.source},
			{"group:stick"},
		}
	})
end
function bk_game.register_hoe(name, def)
	minetest.register_tool(":tools:hoe_"..name, {
		description = def.description.." Hoe",
		inventory_image = "tools_hoe_"..name..".png",
		on_use = function(itemstack, user, pointed_thing)
			-- check if pointing at a node
			if pointed_thing.type ~= "node" then
				return
			end
			local under = minetest.get_node(pointed_thing.under)
			local p = {x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}
			local above = minetest.get_node(p)

			-- return if any of the nodes is not registered
			if not minetest.registered_nodes[under.name] then
				return
			end
			if not minetest.registered_nodes[above.name] then
				return
			end

			-- check if the node above the pointed thing is air
			if above.name ~= "air" then
				return
			end

			-- check if pointing at dirt
			if minetest.get_item_group(under.name, "soil") ~= 1 then
				return
			end

			-- turn the node into soil, wear out item and play sound
			minetest.set_node(pointed_thing.under, {name="flowers:soil"})
			itemstack:add_wear(65535/(def.uses*5-1))
			return itemstack
		end,
	})

	minetest.register_craft({
		output = "tools:hoe_"..name,
		recipe = {
			{def.source, def.source, ""},
			{"", "group:stick", ""},
			{"", "group:stick", ""},
		}
	})
end
function bk_game.register_tools(name, def)
	if not def.source or not def or not name then
		return
	end

	if not def.full_punch_interval then
		def.full_punch_interval = 0.9
	end
	-- Pick
	if def.pick ~= false then
		bk_game.register_pick(name, def)
	end
	-- Shovel
	if def.shovel ~= false then
		bk_game.register_shovel(name, def)
	end
	-- Axe
	if def.axe ~= false then
		bk_game.register_axe(name, def)
	end
	-- Sword
	if def.sword ~= false then
		bk_game.register_sword(name, def)
	end
	-- Hoe
	if def.hoe ~= false then
		bk_game.register_hoe(name, def)
	end
end


-- stone tools

bk_game.register_tools("stone", {
	source = "default:cobble",
	description = "Stone",
	times= {[4] = 5.00,[5] = 3.50, [6]=1.80,},
	uses = 20,
	level = 5,
})

-- The hand

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		groupcaps = {
			crumbly = {times={[1]=5.00, [2]=2.00, [3]=1.00}, uses=0, maxlevel=1},
			snappy = {times={[3]=2.00}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.00,[2]=1.50,[3]=0.7}, uses=0, maxlevel=2}
		},
		damage_groups = {fleshy=1},
	}
})

-- Wooden tools
bk_game.register_tools("wood", {
	description = "Wood",
	source = "group:planks",
	times = {[5] = 4.00, [6]=2.50,},
	uses = 10,
	sword = false, -- no wooden sword
	maxlevel = 5,
})
local adamant_def = {
	description = "Adamant",
	source = "metals:adamant_ingot",
}
bk_game.register_pick("adamant", adamant_def)
bk_game.register_hoe("adamant", adamant_def)
bk_game.register_sword("adamant", adamant_def)
