function register_alloy(name, alloyDef)
	alloyDef.ignot = "alloys:"..name.."_ignot";
	minetest.register_craftitem(alloyDef.ignot, {
		description = alloyDef.description.." Ignot",
		inventory_image = {"alloys_"..name.."_ignot.png" },
	});
	
	alloyDef.source = alloyDef.ignot
   	minetest.register_craft({
   		type = "shapeless",
   		output = alloyDef.ignot,
   		recipe = alloyDef.recipe,
   	})

	alloyDef.stair = true
	alloyDef.slab = true
	bk_game.register_nodes(name, alloyDef)
	bk_game.register_chest(name, alloyDef)
	alloyDef.only_placer_can_open = true
	bk_game.register_door(name,alloyDef)
end

opts = {

["bronze"] = {description= "Bronze", recipe = {"metals:steel_ingot", "metals:copper_ingot", ""}, level=4},

}

for alloy, desc in pairs(opts) do
	register_alloy(alloy, desc)
end

-- tools from alloys only from bronze
bk_game.register_tools("bronze", {
	description= "Bronze",
	level=4,
	times={ [3]=3.70 ,[4]=2.70,[5]=2.20, [6]=1.20,}, 
	uses=30
})
