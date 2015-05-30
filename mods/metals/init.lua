function bk_game.register_metal(name, metal_def)

	-- Register ingot
	metal_def.ingot = "metals:"..name.."_ingot";
	minetest.register_craftitem(":"..metal_def.ingot, {
		description = metal_def.description.." Ingot",
		inventory_image = "metals_"..name.."_ingot.png",
	})

	-- Ways to take the ingot
	if metal_def.isAlloy and metal_def.isAlloy ~= false then
		-- Alloy ingot craft
		minetest.register_craft({
			type = "shapeless",
			output = metal_def.ingot.." "..table.getn(metal_def.recipe),
			recipe = metal_def.recipe,
		})
	else
		-- Register lump
		if not metal_def.lump then
			metal_def.lump = "metals:"..name.."_lump"
		end

		minetest.register_craftitem(":"..metal_def.lump, {
			description = metal_def.description.." Lump",
			inventory_image = "metals_"..name.."_lump.png" ,
		});

		-- Register ore
		bk_game.register_ore(name, metal_def)

		-- Ore ingot craft
		minetest.register_craft({
			type = "cooking",
			output = metal_def.ingot,
			recipe = metal_def.lump,
		})
	end

	-- Register metal products
	metal_def.source = metal_def.ingot
	metal_def.default_texture = "metals_"..name..".png"
	metal_def.tiles = {metal_def.default_texture}
	metal_def.ladders_from_source = 3

-- it`s broken by alloys
	if metal_def.blocks and metal_def.blocks ~= false then
		metal_def.groups = bk_game.groups[name]
		metal_def.stair = true
		metal_def.slab = true
		metal_def.column = true
		metal_def.pyramid = true
		bk_game.register_nodes(name, metal_def)
	end

	if metal_def.tools and metal_def.tools ~= false then
		bk_game.register_tools(name, metal_def)
		bk_game.register_bucket(name, metal_def)
	end

	if metal_def.furniture and metal_def.furniture ~= false then
		bk_game.register_chest(name, metal_def)
	end

	metal_def.only_placer_can_open = true
	bk_game.register_door(name,metal_def)
	bk_game.register_ladder(name, metal_def)
	bk_game.register_fence(name, metal_def)
	
end



metals_list = {
	adamant = {
		description = "Adamant",
		isAlloy = false,
		chunk_size = 3,
		height_min = -37000,
		height_max = -25000,
		blocks = true,
		tools = false,
		furniture = false
	}, -- Adamant pick will be registered separatelly
	mithril = {
		description = "Mithril",
		level = 2,
		uses = 30,
		isAlloy = false,
		height_max = -1000,
		blocks = true,
		tools = true,
		furniture = false
	},
	titan = {
		description = "Titan",
		level = 3,
		uses = 15,
		isAlloy = false,
		height_max = -700,
		blocks = true,
		tools = true,
		furniture = false
	},
	steel = {
		description = "Steel",
		lump = "metals:iron_lump", -- Maybe better to alter descrition rather than internal name?
		level = 3,
		uses = 20,
		isAlloy = false,
		height_max = -600,
		height_min = -17000,
		blocks = true,
		tools = true,
		furniture = false
	},
	gold = {
		description = "Gold",
		level = 5,
		isAlloy = false,
		height_max = -600,
		blocks = true,
		tools = false,
		furniture = false
	},
	silver = {
		description = "Silver",
		level = 4,
		isAlloy = false,
		height_max = -500,
		height_min = -15000,
		blocks = true,
		tools = false,
		furniture = false
	},
	zinc = {
		description = "Zinc",
		level = 5,
		isAlloy = false,
		height_min = -500,
		blocks = true,
		tools = false,
		furniture = false
	},
	aluminium = {
		description = "Aluminium",
		level = 5,
		isAlloy = false,
		height_min = -50,
		blocks = true,
		tools = false,
		furniture = false
	},
	copper = {
		description = "Copper",
		level = 4,
		uses = 10,
		isAlloy = false,
		height_min = -50,
		blocks = true,
		tools = true,
		furniture = false
	},
	bronze = {
		description = "Bronze",
		level = 4,
		uses = 25,
		isAlloy = true,
		recipe = {"metals:copper_ingot", "metals:aluminium_ingot"},
		blocks = true,
		tools = true,
		furniture = false
	},
	brass = {
		description = "Brass",
		level=4,
		uses=25,
		isAlloy = true,
		recipe={"metals:copper_ingot", "metals:copper_ingot", "metals:copper_ingot", "metals:zinc_ingot"},
		blocks = true,
		tools=true,
		furniture=false
	},
	black_gold = {
		description = "Black gold",
		level=5,
		isAlloy = true,
		recipe={"metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "minerals:coal_lump"},
		blocks = true,
		tools = false,
		furniture = false
	},
	green_gold = {
		description = "Green gold",
		level = 5,
		isAlloy = true,
		recipe = {"metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:silver_ingot"},
		blocks = true,
		tools = false,
		furniture = false
	},
	violet_gold = {
		description = "Violet gold",
		level = 5,
		isAlloy = true,
		recipe = {"metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:aluminium_ingot"},
		blocks = true,
		tools = false,
		furniture = false
	},
	rose_gold = {
		description = "Rose gold",
		level = 5,
		isAlloy = true,
		recipe = {"metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:copper_ingot"},
		blocks = true,
		tools = false,
		furniture = false
	}
}

for metal, def in pairs(metals_list) do
    bk_game.register_metal(metal, def)
end
