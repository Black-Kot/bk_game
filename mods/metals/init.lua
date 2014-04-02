function register_metal(name, metalDef)
	if not metalDef.ore and metalDef.ore ~= false then
		if not metalDef.lump then
			metalDef.lump = "metals:"..name.."_lump"
		end
	end

	minetest.register_craftitem(":"..metalDef.lump, {
		description = metalDef.description.." Lump",
		inventory_image = "metals_"..name.."_lump.png" ,
	});
	register_ore(name, metalDef);
	if not metalDef.ingots and metalDef.ingots ~= false then
		if not metalDef.ingot then
			metalDef.ingot = "metals:"..name.."_ingot";
			minetest.register_craftitem(":"..metalDef.ingot, {
				description = metalDef.description.." Ingot",
				inventory_image = "metals_"..name.."_ingot.png",
			})
		end
		if not metalDef.craft and metalDef.craft ~= false then
			if not metalDef.lump then
				metalDef.lump = "metals:"..name.."_lump"
			end
			minetest.register_craft({
				type = "cooking",
				output = metalDef.ingot,
				recipe = metalDef.lump,
			})
		end
	end
	if not metalDef.source then
		if not metalDef.ingot then
			return
		else 
		metalDef.source = metalDef.ingot
		end 
	end

	if not metalDef.block and metalDef.block ~= false then
	metalDef.stair = true
	metalDef.slab = true
	bk_game.register_nodes(name, metalDef)
	end


	if not metalDef.tools and metalDef.tools ~= false then
		register_tools(name, metalDef)
	end
end


list = {
    "adamant",
    "chromium",
    "coal",
    "copper",
    "gold",
    "mithril",
    "silver", 
    "steel",
    "tin",
    "zinc",
	--  "lignite",
	--  "anthracite",
	--  "bituminous_coal",
	--  "magnetite",
	--  "hematite",
	--  "limonite",
	--  "bismuthinite",
	--  "cassiterite",
	--  "galena",
	--  "garnierite",
	--  "malachite",
	--  "native_copper",
	--  "native_gold",
	--  "native_silver",
	--  "native_platinum",
	--  "sphalerite",
	--  "tetrahedrite",
	--  "lazurite",
	--  "bauxite",
	--  "cinnabar",
	--  "cryolite",
	--  "graphite",
	--  "gypsum",
	--  "jet",
	--  "kaolinite",
	--  "kimberlite",
	--  "olivine",
	--  "petrified_wood",
	--  "pitchblende",
	--  "saltpeter",
	--  "satin_spar",
	--  "selenite",
	--  "serpentine",
	--  "sylvite",
	--  "tenorite",
}

opts_list = {
    {description = "Adamant", level=10, uses=100, times={[1]=1,[2]=0.5,[3]=0.25}, },
    {description = "Chromium", tools = false, },
    {description = "Coal", tools = false, ingots = false, block = false, tools = false, },
    {description = "Copper", level=2},
    {description = "Gold", tools = false, },
    {description = "Mithril", level=3},
    {description = "Silver", tools = false, },
    {description = "Steel", lump = "metals:iron_lump", level=2, uses=30, }, 
    {description = "Tin", tools = false, },
    {description = "Zinc", tools = false, }
	--  "Lignite",
	--  "Anthracite",
	--  "Bituminous Coal",
	--  "Magnetite",
	--  "Hematite",
	--  "Limonite",
	--  "Bismuthinite",
	--  "Cassiterite",
	--  "Galena",
	--  "Garnierite",
	--  "Malachite",
	--  "Native Copper",
	--  "Native Gold",
	--  "Native Silver",
	--  "Native Platinum",
	--  "Sphalerite",
	--  "Tetrahedrite",
	--  "Lazurite",
	--  "Bauxite",
	--  'Cinnabar',
	--  'Cryolite',
	--  'Graphite',
	--  'Gypsum',
	--  'Jet',
	--  'Kaolinite',
	--  'Kimberlite',
	--  'Olovine',
	--  'Petrified wood',
	--  'Pitchblende',
	--  'Saltpeter',
	--  'Satin Spar',
	--  'Selenite',
	--  'Serpentine',
	--  'Sylvite',
	--  'Tenorite',
}

for _, metal in ipairs(list) do
    register_metal(metal, opts_list[_]) 
end

