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

-- register_node(name, alloyDef)
end

opts = {

bronze = {description= "Bronze", recipe = {"metals:steel_ingot", "metals:copper_ingot", ""}, },

}

for desc, alloy in ipairs(opts) do
	register_alloy(alloy, desc)
end
