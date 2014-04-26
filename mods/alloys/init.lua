function register_alloy(name, alloyDef)

alloyDef.ignot = "alloys:"..name.."_ignot";

minetest.register_craftitem(alloyDef.ignot, {
	description = alloyDef.description.." Ignot",
	inventory_image = {"alloys_"..name.."_ignot.png" },
});

   	minetest.register_craft({
   		type = "shapeless",
   		output = alloyDef.ignot,
   		recipe = alloyDef.recipe,
   	})

 bk_game.register_nodes(name, alloyDef)
end

opts = {

bronze = {description= "Bronze", recipe = {"metals:steel_ingot", "metals:copper_ingot", ""}, level=4},

}

for desc, alloy in ipairs(opts) do
	register_alloy(alloy, desc)
end

bk_game.register_tools("bronze", {
	description= "Bronze",
	level=4, 
	times={ [3]=3.00, [4]=2.50, [5]=2.00, [6]=1.60, [7]=1.00, [8]=0.80,},
	uses=30
})
