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
				{'', 'group:stick', ''},
				{'', 'group:stick', ''},
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
				{'group:stick'},
				{'group:stick'},
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
				{toolDef.source, 'group:stick'},
				{'', 'group:stick'},
			}
		})
	end

	-- Sword`s
if not string.match(toolDef.source, "stick") then
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
				{'group:stick'},
			}
		})
	end
	
end

print("Register Tools "..toolDef.description.." [OK]")

end


-- stone tools

bk_game.register_tools("stone", {
	source = "default:stone",
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
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={ [6]=2.50,}, uses=0, maxlevel=1},
			snappy = {times={[6]=2.50}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=6.00,[2]=3.00,[3]=1.50}, uses=0, maxlevel=2}
		},
		damage_groups = {fleshy=1},
	}
})

-- Wood/Stick tools

	bk_game.register_tools("wood", {
		description = "Wood",
		source = "group:stick",
		times = {[5] = 4.00, [6]=2.50,}, 
		uses = 10,
		maxlevel = 5,
	})

-- Adamant Pick, can dig all

		minetest.register_tool("tools:pick_adamant", {
			description = "Adamant Pickaxe",
			inventory_image = "tools_pick_adamant.png",
			tool_capabilities = {
				full_punch_interval = 0.20,
				max_drop_level=8,
				groupcaps={
					cracky = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, } , uses=0, maxlevel=6},
					crumbly = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, } , uses=0, maxlevel=6},
					choppy = {times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50, } , uses=0, maxlevel=6},
				},
				damage_groups = {cracky=8},
			},
		})
		minetest.register_craft({
			output = "tools:pick_adamant",
			recipe = {
				{"metals_adamant_lump.png", "metals_adamant_lump.png", "metals_adamant_lump.png"},
				{'', 'group:stick', ''},
				{'', 'group:stick', ''},
			}
		})
