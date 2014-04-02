function register_mineral(name, mineralDef)
	mineralDef.lump = "minerals:"..name.."_lump";
	minetest.register_craftitem(mineralDef.lump, {
		description = mineralDef.description.." Lump",
		inventory_image = {"mineral_"..name.."_lump.png" },
	});
	mineralDef.source = mineralDef.lump
	if not mineralDef.block and mineralDef.block ~= false then
	mineralDef.stair = true
	mineralDef.slab = true
	bk_game.register_nodes(name, mineralDef)
	end	
	register_ore(name, mineralDef);
end
