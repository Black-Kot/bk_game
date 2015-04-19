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
		if mineralDef.flat == nil then
			mineralDef.flat = true
		end
		if mineralDef.brick == nil then
			mineralDef.brick = true
		end
		bk_game.register_nodes(name, mineralDef)
	end
	if not mineralDef.chest and mineralDef.chest ~= false then
		bk_game.register_chest(name, mineralDef)
	end

	--bk_game.register_door(name, mineralDef)  -- no doors from minerals
	--bk_game.register_fence(name, mineralDef) -- no fences from minerals
end

minerals_list = {
	cinnabar = {
		description = "Cinnabar",
		brick = false
	},
	coal = {
		description = "Coal",
		chest = false,
		block=true,
		slab = false,
		brick = false,
		stair = false,
		flat = false,
		column = false,
		pyramid = false,
	},
	gypsum = {
		description = "Gypsum",
		brick = false
	},
	jet = {
		description = "Jet",
		brick = false
	},
	lazurite = {
		description = "Lazurite",
		brick = false
	},
	malachite = {
		description = "Malachite",
		brick = false
	},
	olivine = {
		description = "Olivine",
		brick = false
	},
	petrified_wood = {
		description = "Petrified Wood",
		brick = false
	},
	satin_spar = {
		description = "Satin Spar",
		brick = false
	},
	selenite = {
		description = "Selenite",
		brick = false
	},
	serpentine = {
		description = "Serpentine",
		brick = false,
	},
	uranium = {
		description = "Uranium",
		chest=false,
		brick = false,
		block=false,
		height_max=-8000
	}
}

for mineral, def in pairs(minerals_list) do
    bk_game.register_mineral(mineral, def)
end
