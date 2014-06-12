-- mods/default/crafting.lua

minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"blocks:stone", "blocks:stone", "blocks:stone"},
		{"blocks:stone", "", "blocks:stone"},
		{"blocks:stone", "blocks:stone", "blocks:stone"},
	}
})

minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"blocks:desert_stone", "blocks:desert_stone", "blocks:desert_stone"},
		{"blocks:desert_stone", "", "blocks:desert_stone"},
		{"blocks:desert_stone", "blocks:desert_stone", "blocks:desert_stone"},
	}
})

minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "", "default:cobble"},
		{"default:cobble", "default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"default:desert_cobble", "default:desert_cobble", "default:desert_cobble"},
		{"default:desert_cobble", "", "default:desert_cobble"},
		{"default:desert_cobble", "default:desert_cobble", "default:desert_cobble"},
	}
})

minetest.register_craft({
	output = "blocks:clay",
	recipe = {
		{"default:clay_lump", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump"},
	}
})

minetest.register_craft({
	output = "blocks:brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick"},
	}
})

minetest.register_craft({
	output = "default:clay_brick 4",
	recipe = {
		{"default:brick"},
	}
})

minetest.register_craft({
	output = "default:paper",
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"},
	}
})

minetest.register_craft({
	output = "default:book",
	recipe = {
		{"default:paper"},
		{"default:paper"},
		{"default:paper"},
	}
})

minetest.register_craft({
	output = "default:sign_wall",
	recipe = {
		{"group:planks", "group:planks", "group:planks"},
		{"group:planks", "group:planks", "group:planks"},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:scaffolding 3",
	recipe = {
		{"group:planks", "group:planks", "group:planks"},
		{"", "group:stick", ""},
		{"group:stick", "", "group:stick"},
	}
})

--
-- Crafting (tool repair)
--
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})

--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "blocks:glass",
	recipe = "group:sand",
})

minetest.register_craft({
	type = "cooking",
	output = "blocks:obsidian_glass",
	recipe = "blocks:obsidian_shard",
})

minetest.register_craft({
	type = "cooking",
	output = "blocks:stone",
	recipe = "default:cobble",
})
minetest.register_craft({
	type = "cooking",
	output = "blocks:desert_stone",
	recipe = "default:desert_cobble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "default:clay_lump",
})
minetest.register_craft({
	type = "cooking",
	output = "default:torch",
	recipe = "group:stick",
})


--
-- Fuels
--

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:planks",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:log",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:papyrus",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:ladder",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:torch",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sign_wall",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:chest",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:chest_locked",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:nyancat",
	burntime = 100,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:nyancat_rainbow",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:coal_lump",
	burntime = 250,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglesapling",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:scaffolding",
	burntime = 15,
})
