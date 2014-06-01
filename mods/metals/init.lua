function bk_game.register_metal(name, metalDef)

	-- Register ingot
	metalDef.ingot = "metals:"..name.."_ingot";
	minetest.register_craftitem(":"..metalDef.ingot, {
		description = metalDef.description.." Ingot",
		inventory_image = "metals_"..name.."_ingot.png",
	})

	-- Ways to take the ingot
	if metalDef.isAlloy and metalDef.isAlloy ~= false then
		-- Alloy ingot craft
		minetest.register_craft({
			type = "shapeless",
			output = metalDef.ingot.." "..table.getn(metalDef.recipe),
			recipe = metalDef.recipe,
		})
	else
		-- Register lump
		if not metalDef.lump then
			metalDef.lump = "metals:"..name.."_lump"
		end

		minetest.register_craftitem(":"..metalDef.lump, {
			description = metalDef.description.." Lump",
			inventory_image = "metals_"..name.."_lump.png" ,
		});

		-- Register ore
		bk_game.register_ore(name, metalDef)

		-- Ore ingot craft
		minetest.register_craft({
			type = "cooking",
			output = metalDef.ingot,
			recipe = metalDef.lump,
		})
	end

	-- Register metal products
	metalDef.source = metalDef.ingot
	metalDef.default_texture = "metals_"..name..".png"

-- it`s broken by alloys
	if metalDef.blocks and metalDef.blocks ~= false then
		metalDef.stair = true
		metalDef.slab = true
		metalDef.column = true
		metalDef.pyramid = true
		bk_game.register_nodes(name, metalDef)
	end

	if metalDef.tools and metalDef.tools ~= false then
		bk_game.register_tools(name, metalDef)
		bk_game.register_bucket(name, metalDef)
	end

	if metalDef.furniture and metalDef.furniture ~= false then
		bk_game.register_chest(name, metalDef)
	end

	metalDef.only_placer_can_open = true
	bk_game.register_door(name,metalDef)
	bk_game.register_ladder(name, metalDef)
end



metalList = {
	["adamant"] =	{
						description = "Adamant",
						level=1, uses=0, times={ [1]=1.00, [2]=0.80, [3]=0.80, [4]=0.80, [5]=0.80, [6]=0.80}, full_punch_interval=0.20,
						isAlloy = false, chunk_size=3, height_min=-37000, height_max=-25000,
						blocks = true, tools=false, furniture=false
					}, -- Adamant pick will be registered separatelly
	["mithril"] =	{
						description = "Mithril",
						level=2, uses=30, times={ [2]=2.80, [3]=2.20, [4]=1.50, [5]=1.20, [6]=0.80, },
						isAlloy = false, height_max=-10000,
						blocks = true, tools=true, furniture=false
					},
	["titan"] =		{
						description = "Titan",
						level=3, uses=15, times={ [3]=2.50, [4]=1.70, [5]=1.30, [6]=0.90, },
						isAlloy = false, height_max=-5000,
						blocks = true, tools=true, furniture=false
					},
	["steel"] =		{
						description = "Steel", lump = "metals:iron_lump", -- Maybe better to alter descrition rather than internal name?
						level=3, uses=20,  times={ [3]=2.70 ,[4]=1.80,[5]=1.40, [6]=1.00 },
						isAlloy = false, height_max=-250, height_max=-17000,
						blocks = true, tools=true, furniture=false
					},
	["gold"] =		{
						description = "Gold",
						level=5,
						isAlloy = false, height_max=-1000,
						blocks = true, tools=false, furniture=false
					},
	["silver"] =	{
						description = "Silver",
						level=4,
						isAlloy = false, height_max=-500, height_min=-15000,
						blocks = true, tools=false, furniture=false
					},
	["zinc"] =		{
						description = "Zinc",
						level=5,
						isAlloy = false, height_min=-9000,
						blocks = true, tools=false, furniture=false
					},
	["aluminium"] =	{
						description = "Aluminium",
						level=5,
						isAlloy = false, height_min=-9000,
						blocks = true, tools=false, furniture=false
					},
	["copper"] =	{
						description = "Copper",
						level=4, uses=10,  times={ [4]=2.40,[5]=2.00, [6]=1.70},
						isAlloy = false, height_min=-17000,
						blocks = true, tools=true, furniture=false
					},
	["bronze"] =	{
						description = "Bronze",
						level=4, uses=25,  times={ [4]=1.90,[5]=1.70, [6]=1.40},
						isAlloy = true, recipe={ "metals:copper_ingot", "metals:aluminium_ingot" },
						blocks = true, tools=true, furniture=true
					},
	["brass"] =		{
						description = "Brass",
						level=4, uses=25,  times={ [4]=2.10,[5]=1.80, [6]=1.50},
						isAlloy = true, recipe={ "metals:copper_ingot", "metals:copper_ingot", "metals:copper_ingot", "metals:zinc_ingot" },
						blocks = true, tools=true, furniture=false
					},
	["black_gold"] =	{
							description = "Black gold",
							level=5,
							isAlloy = true, recipe={ "metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "minerals:coal_lump" },
							blocks = true, tools=false, furniture=false
						},
	["green_gold"] =	{
							description = "Green gold",
							level=5,
							isAlloy = true, recipe={ "metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:silver_ingot" },
							blocks = true, tools=false, furniture=false
						},
	["violet_gold"] =	{
							description = "Violet gold",
							level=5,
							isAlloy = true, recipe={ "metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:aluminium_ingot" },
							blocks = true, tools=false, furniture=false
						},
	["rose_gold"] =		{
							description = "Rose gold",
							level=5,
							isAlloy = true, recipe={ "metals:gold_ingot", "metals:gold_ingot", "metals:gold_ingot", "metals:copper_ingot" },
							blocks = true, tools=false, furniture=false
						},
}



for metal, descr in pairs(metalList) do
    bk_game.register_metal(metal, descr)
end
