function register_mineral(name, mineralDef)
	mineralDef.lump = "minerals:"..name.."_lump";
	minetest.register_craftitem(mineralDef.lump, {
		description = mineralDef.description.." Lump",
		inventory_image = {"mineral_"..name.."_lump.png" },
	});
	register_ore(name, mineralDef);
end
