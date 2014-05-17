function bk_game.register_tools(name, toolDef) 
	if not toolDef.source or not toolDef or not name then
		return
	end
	if not toolDef.times then
		toolDef.times={ [1]=10.00, [2]=9.00, [3]=8.00, [4]=7.00, [5]=6.00, [6]=5.00, [7]=4.00, [8]=3.00, [9]=2.00, [10]=1.00,}
	end
	if not toolDef.uses then
		toolDef.uses = 10
	end
	if not toolDef.level then
		toolDef.level = 5
	end

	if not toolDef.full_punch_interval then
		toolDef.full_punch_interval = 0.9
	end
	-- Picks
	if not toolDef.pick and toolDef.pick ~= false then
		minetest.register_tool(":tools:pick_"..name, {
			description = toolDef.description.." Pickaxe",
			inventory_image = "tools_pick_"..name..".png",
			tool_capabilities = {
				full_punch_interval = toolDef.full_punch_interval,
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

bk_game.register_tools("stone", {
	source = "default:stone",
	description = "Stone",
	times= {[6] = 2.80,[7] = 2.00, [8]=1.80,},
	uses = 20,
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
			crumbly = {times={ [6]=3.00, [7]=2.50,[8]=2.00,}, uses=0, maxlevel=2},
			snappy = {times={[7]=2.50}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=4.00,[2]=2.00,[3]=1.40}, uses=0, maxlevel=2}
		},
		damage_groups = {fleshy=1},
	}
})

-- Adamant Pick, can dig all

		minetest.register_tool("tools:pick_adamant", {
			description = "Adamant Pickaxe",
			inventory_image = "tools_pick_adamant.png",
			tool_capabilities = {
				full_punch_interval = 0.20,
				max_drop_level=8,
				groupcaps={
					cracky = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, [7]=0.50, [8]=0.50,} , uses=0, maxlevel=8},
					crumbly = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, [7]=0.50, [8]=0.50,} , uses=0, maxlevel=8},
					choppy = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, [7]=0.50, [8]=0.50,} , uses=0, maxlevel=8},
				},
				damage_groups = {cracky=8},
			},
		})
		minetest.register_craft({
			output = "tools:pick_adamant",
			recipe = {
				{"metals_adamant_lump.png", "metals_adamant_lump.png", "metals_adamant_lump.png"},
				{'', 'default:stick', ''},
				{'', 'default:stick', ''},
			}
		})
