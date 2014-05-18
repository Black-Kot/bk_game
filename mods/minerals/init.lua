function bk_game.register_mineral(name, mineralDef)
	mineralDef.lump = "minerals:"..name.."_lump";
	minetest.register_craftitem(":"..mineralDef.lump, {
		description = mineralDef.description.." Lump",
		inventory_image = {"minerals_"..name.."_lump.png" },
	});
	mineralDef.source = mineralDef.lump
	mineralDef.level=5
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
end

list = {
	'cinnabar',
	'coal',
	'gypsum',
	'jet',
	'lazurite',
	'malachite',
	'olivine',
	'petrified_wood',
	'satin_spar',
	'selenite',
	'serpentine'
}

opts_list = {
    {description = "Cinnabar", },
    {description = "Coal", chest=false, stair=false, slab=false, pyramid=false, column=false},
    {description = "Gypsum", },
    {description = "Jet", },
    {description = "Lazurite", },
    {description = "Malachite", },
    {description = "Olivine", },
    {description = "Petrified Wood", },
    {description = "Satin Spar", },
    {description = "Selenite", },
    {description = "Serpentine", }
}

for _, mineral in ipairs(list) do
    bk_game.register_mineral(mineral, opts_list[_]) 
end
