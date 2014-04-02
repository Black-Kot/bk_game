function register_crystal(name, crystalDef)

if not crystalDef.ore and crystalDef.ore ~= false then

if not crystalDef.lump then
crystalDef.lump = "crystals:"..name;
end

minetest.register_craftitem(":"..crystalDef.lump, {
	description = crystalDef.description.." Crystal",
	inventory_image = "crystals_"..name..".png" ,
});

minetest.register_craftitem(":"..crystalDef.lump.."_fragment", {
	description = crystalDef.description.." Crystal Fragment",
	inventory_image = "crystals_"..name.."_fragment.png",
})

minetest.register_craft({
	output = crystalDef.lump..'_fragment 9',
	recipe = {
		{crystalDef.lump},
	}
})

minetest.register_craft({
	output = crystalDef.lump,
	recipe = {
		{crystalDef.lump..'_fragment', crystalDef.lump..'_fragment', crystalDef.lump..'_fragment'},
		{crystalDef.lump..'_fragment', crystalDef.lump..'_fragment', crystalDef.lump..'_fragment'},
		{crystalDef.lump..'_fragment', crystalDef.lump..'_fragment', crystalDef.lump..'_fragment'},
	}
})

register_ore(name, crystalDef);
end

end

list = {
	"diamond",
	"mese",
}

opts_list = {
	{description = "Diamond", },
	{description = "Mese", },
}

for _, crystal in ipairs(list) do
	register_crystal(crystal, opts_list[_])
end

-- fix for default:mese

minetest.register_alias("default:mese", ":crystals:mese")
