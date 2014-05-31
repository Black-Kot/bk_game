function bk_game.register_mineral(name, mineralDef)
	mineralDef.lump = "minerals:"..name.."_lump";
	minetest.register_craftitem(":"..mineralDef.lump, {
		description = mineralDef.description.." Lump",
		inventory_image = "minerals_"..name.."_lump.png"
	});
	mineralDef.source = mineralDef.lump
	mineralDef.level=4
	bk_game.register_ore(name, mineralDef)
	
	if not mineralDef.block and mineralDef.block ~= false then
		if mineralDef.stair == nil then
			mineralDef.stair = true
		end
		if mineralDef.slab == nil then
			mineralDef.slab = true
		end
		if mineralDef.column == nil then
			mineralDef.column = true
		end
		if mineralDef.pyramid == nil then
			mineralDef.pyramid = true
		end
		bk_game.register_nodes(name, mineralDef)
	end	
	if not mineralDef.chest and mineralDef.chest ~= false then
		bk_game.register_chest(name, mineralDef)
	end
	
	--bk_game.register_door(name, mineralDef)  -- no doors from minerals
end

list = {
    ["cinnabar"] = {description = "Cinnabar", },
    ["coal"] = {description = "Coal", chest=false, stair=false, slab=false, pyramid=false, column=false},
    ["gypsum"] = {description = "Gypsum", },
    ["jet"] = {description = "Jet", },
    ["lazurite"] = {description = "Lazurite", },
    ["malachite"] = {description = "Malachite", },
    ["olivine"] = {description = "Olivine", },
    ["petrified_wood"] = {description = "Petrified Wood", },
    ["satin_spar"] = {description = "Satin Spar", },
    ["selenite"] = {description = "Selenite", },
    ["serpentine"] = {description = "Serpentine", }
}

for mineral, desc in ipairs(list) do
    bk_game.register_mineral(mineral, desc) 
end
