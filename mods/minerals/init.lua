function bk_game.register_mineral(name, mineralDef)
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
	bk_game.register_ore(name, mineralDef)
	bk_game.register_chest(name, mineralDef)
	
end

list = {
    "coal",
	"lignite",
	"anthracite",
	"bituminous_coal",
	"bismuthinite",
	"malachite",
	"sphalerite",
	"lazurite",
	"cryolite",
	"graphite",
	"gypsum",
	"jet",
	"kaolinite",
	"kimberlite",
	"olivine",
	"petrified_wood",
	"pitchblende",
	"saltpeter",
	"satin_spar",
	"selenite",
	"serpentine",
	"sylvite",
}

opts_list = {
    {description = "Coal", },
	{description = "Lignite", },
	{description = "Anthracite", },
	{description = "Bituminous Coal", },
	{description = "Bismuthinite", },
	{description = "Malachite", },
	{description = "Sphalerite", },
	{description = "Lazurite", },
	{description = 'Cryolite', },
	{description = 'Graphite', },
	{description = 'Gypsum', },
	{description = 'Jet', },
	{description = 'Kaolinite', },
	{description = 'Kimberlite', },
	{description = 'Olovine', },
	{description = 'Petrified wood', },
	{description = 'Pitchblende', },
	{description = 'Saltpeter', },
	{description = 'Satin Spar', },
	{description = 'Selenite', },
	{description = 'Serpentine', },
	{description = 'Sylvite', },
}

for _, mineral in ipairs(list) do
    bk_game.register_mineral(mineral, opts_list[_]) 
end
