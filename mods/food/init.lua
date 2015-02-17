function bk_game.register_food(name, def)

	if def.tree then
		bk_game.register_tree(name, def)

	else

		def.drop = "food:"..name
		bk_game.register_flower(name, def)

		if def.cook then

			minetest.register_craftitem(":food:"..name, {
				description = def.description,
				inventory_image = "food_"..name..".png",
			})


			minetest.register_craftitem(":food:cooked_"..name, {
				description = "Cooked " .. def.description,
				inventory_image = "food_cooked_"..name..".png",
				on_use = function(itemstack, user, pointed_thing)
					if user:get_hp() < 20 then
						itemstack = minetest.do_item_eat(def.eat_price, nil, itemstack, user, pointed_thing)
					end
					return itemstack
				end

			})

			minetest.register_craft({
				type = "cooking",
				output = "food:cooked_"..name,
				recipe = "food:"..name,
			})

		else

			minetest.register_craftitem(":food:"..name, {
				description = def.description,
				inventory_image = "food_"..name..".png",
				on_use = function(itemstack, user, pointed_thing)
					if user:get_hp() < 20 then
						itemstack = minetest.do_item_eat(def.eat_price, nil, itemstack, user, pointed_thing)
					end
					return itemstack
				end

			})
		end
	end
end

local GROWING_DELAY = 3600


dofile(minetest.get_modpath("food").."/leavesgen.lua")
food_list = {
	potato = {
		description = "Potato",
		tree = false,
		interval = GROWING_DELAY/2,
		chance = 4,
		spacing = 15,
		nodenames = {"default:dirt_with_grass"},
		pot = false,
		seed = true,
		cook = true,
		eat_price = 1
	},
	carrot = {
		description = "Carrot",
		tree = false,
		interval = GROWING_DELAY/2,
		chance = 4,
		spacing = 15,
		nodenames = {"default:dirt_with_grass"},
		pot = false,
		seed = true,
		cook = false,
		eat_price = 1
	},
	raspberry = {
		description = "Raspberry",
		tree = false,
		interval = GROWING_DELAY/2,
		chance = 4,
		spacing = 15,
		nodenames = {"default:dirt_with_grass"},
		pot = false,
		seed = true,
		cook = false,
		eat_price = 1
	},
	coconut = {
		description = "Coconut",
		tree = true,
		leaves = trees.gen_lists.coconut,
		height = function()
			return 22 + math.random(6)
		end,
		fruit = "coconut",
		eat_price = 1
	},
	apple = {
		description = "Apple",
		tree = true,
		leaves = trees.gen_lists.apple,
		height = function()
			return 4 + math.random(3)
		end,
		fruit = "apple",
		eat_price = 1
	},
	orange = {
		description = "Orange",
		tree = true,
		leaves = trees.gen_lists.orange,
		height = function()
			return 6 + math.random(2)
		end,
		fruit = "orange",
		eat_price = 1
	}
}

for food, descr in pairs(food_list) do
    bk_game.register_food(food, descr)
end
