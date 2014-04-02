function register_tools(name, toolDef) 
	if not toolDef.source or not toolDef or not name then
		return
	end
	if not toolDef.times then
		toolDef.times={ [1]=1.00, [2]=2.00, [3]=3.00}
	end
	if not toolDef.uses then
		toolDef.uses = 10
	end
	if not toolDef.level then
		toolDef.level = 5
	end

	-- Picks
	if not toolDef.pick and toolDef.pick ~= false then
		minetest.register_tool(":tools:pick_"..name, {
			description = toolDef.description.." Pickaxe",
			inventory_image = "tools_pick_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					cracky = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {cracky=toolDef.level},
			},
		})
		minetest.register_craft({
			output = "tools:pick_"..name,
			recipe = {
				{toolDef.source, toolDef.source, toolDef.source},
				{'', 'default:stick', ''},
				{'', 'default:stick', ''},
			}
		})
	end

	-- Shovels
	if not toolDef.shovel and toolDef.shovel ~= false then
		minetest.register_tool(":tools:shovel_"..name, {
			description = toolDef.description.." Shovel",
			inventory_image = "tools_shovel_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					crumbly = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {crumbly=toolDef.level},
			},
		})

		minetest.register_craft({
			output = "tools:shovel_"..name,
			recipe = {
				{toolDef.source},
				{'default:stick'},
				{'default:stick'},
			}
		})
	end

	-- Axes
	if not toolDef.axe and toolDef.axe ~= false then
		minetest.register_tool(":tools:axe_"..name, {
			description = toolDef.description.." Axe",
			inventory_image = "tools_axe_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					choppy = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {choppy=toolDef.level},
			},
		})

		minetest.register_craft({
			output = "tools:axe_"..name,
			recipe = {
				{toolDef.source, toolDef.source},
				{toolDef.source, 'default:stick'},
				{'', 'default:stick'},
			}
		})
	end

	-- Sword`s

	if not toolDef.sword and toolDef.sword ~= false then
		minetest.register_tool(":tools:sword_"..name, {
			description = toolDef.description.." Sword",
			inventory_image = "tools_sword_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					snappy = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {snappy=toolDef.level},
			},
		})
		minetest.register_craft({
			output = "tools:sword_"..name,
			recipe = {
				{toolDef.source},
				{toolDef.source},
				{'default:stick'},
			}
		})
	end



end


-- stone tools

register_tools("stone", {
	source = "default:stone",
	description = "Stone",
	times= {[1] = 4.0,[2] = 6.0},
	uses = 5,
	level = 2,
})

-- The hand

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={ [1]=1.00, [2]=2.00}, uses=0, maxlevel=1},
			snappy = {times={[1]=0.50}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=1.40,[2]=4.00,[3]=7}, uses=0, maxlevel=2}
		},
		damage_groups = {fleshy=1},
	}
})
