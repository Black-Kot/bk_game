bk_game.registered_trees = {}
bk_game.registered_trees_list = {}

function bk_game.register_tree(name, TreeDef)
	local tree = {
		name = name,
		description = TreeDef.description or "",
		grounds = TreeDef.grounds or {"default:dirt","default:dirt_with_grass"},
		leaves = TreeDef.leaves or {},
		height = TreeDef.height or function() return 10 end,
		radius = TreeDef.radius or 5,
		textures = TreeDef.textures or {},
		grow_interval = TreeDef.grow_interval or 60,
		grow_chance = TreeDef.grow_chance or 20,
		grow_light = TreeDef.grow_light or 8,
		gen_autumn_leaves = false,
		gen_winter_leaves = false,
		fruit = TreeDef.fruit,
		fruit_name = TreeDef.fruit_name,
		fruit_grow_chance = TreeDef.fruit_grow_chance or 20,
		eat_price = TreeDef.eat_price or 1
	}
	if TreeDef.gen_autumn_leaves then
		tree.gen_autumn_leaves = true
	end
	if TreeDef.gen_winter_leaves then
		tree.gen_winter_leaves = true
	end
	tree.textures.trunk = tree.textures.trunk or {"trees_"..name.."_trunk_top.png", "trees_"..name.."_trunk_top.png", "trees_"..name.."_trunk.png"}
	tree.textures.leaves = tree.textures.leaves or "trees_"..name.."_leaves.png"
	tree.textures.autumn_leaves = tree.textures.autumn_leaves or "trees_"..name.."_autumn_leaves.png"
	tree.textures.winter_leaves = tree.textures.winter_leaves or "trees_"..name.."_winter_leaves.png"
	tree.textures.planks = tree.textures.planks or "trees_"..name.."_planks.png"
	tree.textures.stick = tree.textures.stick or "trees_"..name.."_stick.png"
	tree.textures.sapling = tree.textures.sapling or "trees_"..name.."_sapling.png"
	tree.textures.log = tree.textures.log or "trees_"..name.."_log.png"

	bk_game.registered_trees[name] = tree
	table.insert(bk_game.registered_trees_list, tree.name)
	
	if tree.fruit ~= nil then
		local f_name
		if tree.fruit_name ~= nil then
			f_name = tree.fruit_name
		else
			f_name = tree.fruit:gsub("^%l", string.upper)
		end
		minetest.register_node(":trees:"..tree.fruit, {
			description = f_name,
			drawtype = "plantlike",
			tiles = {"trees_"..tree.fruit..".png"},
			inventory_image = "trees_"..tree.fruit..".png",
			paramtype = "light",
			walkable = false,
			on_use = minetest.item_eat(tree.eat_price),
			groups = {snappy=6, dig_immediate=3}
		})
	end
	minetest.register_craftitem(":trees:"..tree.name.."_stick", {
		description = tree.description.." Stick",
		inventory_image = tree.textures.stick,
		groups = {stick=1},
	})

	minetest.register_node(":trees:"..tree.name.."_sapling", {
		description = tree.description.." Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = {tree.textures.sapling},
		inventory_image = tree.textures.sapling,
		wield_image = tree.textures.sapling,
		paramtype = "light",
		walkable = false,
		groups = {snappy=6,dig_immediate=3,flammable=2},
		sounds = default.node_sound_defaults(),
		on_place = function(itemstack,placer,pt)
			local p=minetest.get_pointed_thing_position(pt, false)
			local n=minetest.get_node(p)
			if string.match(n.name,"sapling")~=nil then return
			else
				minetest.add_node(pt.above,{name="trees:"..tree.name.."_sapling"})
				itemstack:take_item()
			end
			return itemstack
		end
	})


	minetest.register_node(":trees:"..tree.name.."_log", {
		description = tree.description.." Log",
		tiles = tree.textures.trunk,
		inventory_image = tree.textures.log,
		wield_image = tree.textures.log,
		groups = {log=1,choppy=5,snappy=5,flammable=2,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = "trees:"..tree.name.."_log",
		paramtype = "light",
	})

	minetest.register_node(":trees:"..tree.name.."_leaves", {
		description = tree.description.." Leaves",
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles = {tree.textures.leaves},
		paramtype = "light",
		groups = {choppy=4, oddly_breakable_by_hand=2, flammable=2, leaves=1},
		drop = {
			max_items = 1,
			items = {
				{
					items = {"trees:"..tree.name.."_sapling"},
					rarity = 30,
				},
				{
					items = {"trees:"..tree.name.."_stick"},
					rarity = 10,
				},
				{
					items = {},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		climbable = true,
	})

	if tree.gen_autumn_leaves then
		minetest.register_node(":trees:"..tree.name.."_leaves_autumn", {
			description = tree.description.." Leaves",
			drawtype = "allfaces_optional",
			visual_scale = 1.3,
			tiles = {tree.textures.autumn_leaves},
			paramtype = "light",
			groups = {snappy=5, flammable=2,drop_on_dig=1,leaves=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {"trees:"..tree.name.."_sapling"},
						rarity = 30,
					},
					{
						items = {"trees:"..tree.name.."_stick"},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			climbable = true,
		})
	end

	if tree.gen_winter_leaves then
		minetest.register_node(":trees:"..tree.name.."_leaves_winter", {
			description = tree.description.." Leaves",
			drawtype = "allfaces_optional",
			visual_scale = 1.3,
			tiles = {tree.textures.autumn_leaves},
			paramtype = "light",
			groups = {snappy=5,flammable=2,drop_on_dig=1,leaves=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {"trees:"..tree.name.."_stick"},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			climbable = true,
		})
	end

	minetest.register_node(":trees:"..tree.name.."_trunk", {
		description = tree.description.." Trunk",
		tiles = tree.textures.trunk,
		groups = {tree=1,choppy=5,snappy=5,flammable=2,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = "trees:"..tree.name.."_log",
		paramtype = "light",
		after_dig_node = function(pos, oldnode, oldmeta, digger)
			if not digger then return end
			local p={x=pos.x,y=pos.y+1,z=pos.z}
			local n=minetest.get_node(p)
			if string.match(n.name,"_trunk") then
				minetest.node_dig(p,n,digger)
			end
		end
	})

	minetest.register_node(":trees:"..tree.name.."_trunk_top", {
		tiles = tree.textures.trunk,
		groups = {tree=1,choppy=5,snappy=5,flammable=2,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = "trees:"..tree.name.."_log",
		paramtype = "light",
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			for i = 1,#tree.leaves do
				local p = {x=pos.x+tree.leaves[i][1], y=pos.y+tree.leaves[i][2], z=pos.z+tree.leaves[i][3]}
				if minetest.get_node(p).name == "trees:"..tree.name.."_leaves" then
					local n = minetest.get_node(p)
					minetest.node_dig(p,n,digger)
				end
			end
		end,
	})
	
	bk_game.register_nodes(tree.name.."_planks", {
		slab=true,
		stair=true,
		description = tree.description.." Planks",
		tiles = {tree.textures.planks},
		groups = {planks=1,snappy=5,choppy=5,oddly_breakable_by_hand=2,flammable=3,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
	})

	bk_game.register_fence(tree.name, {
		description = tree.description,
		source = "blocks:"..tree.name.."_planks",
		tiles = {tree.textures.planks},
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "blocks:"..tree.name.."_planks",
		recipe = {"trees:"..tree.name.."_log"}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "trees:"..tree.name.."_leaves",
		recipe = {"trees:"..tree.name.."_sapling"}
	})

	bk_game.register_chest(name, {
		description = tree.description,
		source = "blocks:"..tree.name.."_planks",
	})

	bk_game.register_ladder(name ,{
		description = tree.description,
		source = "trees:"..tree.name.."_stick",
		tiles = {tree.textures.planks},
	})

	bk_game.register_door(tree.name, {
		description = tree.description,
		source = "blocks:"..tree.name.."_planks",
		description = tree.description,
		main_texture = tree.textures.planks,
	})

	minetest.register_abm({
		nodenames = {"trees:"..tree.name.."_sapling"},
		neighbors = tree.grounds,
		interval = tree.grow_interval,
		chance = tree.grow_chance,
		action = function(pos, node)
			if not minetest.get_node_light(pos) then
				return
			end
			if minetest.get_node_light(pos) >= tree.grow_light then
				trees.make_tree(pos, tree.name)
			end
		end,
	})
end

bk_game.register_tree("ash", {
	description = "Ash",
	leaves = trees.gen_lists.ash,
	height = function()
		return 4 + math.random(4)
	end,
})
bk_game.register_tree("aspen", {
	description = "Aspen",
	leaves = trees.gen_lists.aspen,
	height = function()
		return 10 + math.random(4)
	end,
})
bk_game.register_tree("birch", {
	description = "Birch",
	leaves = trees.gen_lists.birch,
	height = function()
		return 10 + math.random(4)
	end,
})
bk_game.register_tree("maple", {
	description = "Maple",
	leaves = trees.gen_lists.maple,
	height = function()
		return 7 + math.random(5)
	end,
})
bk_game.register_tree("chestnut", {
	description = "Chestnut",
	leaves = trees.gen_lists.chestnut,
	height = function()
		return 9 + math.random(2)
	end,
	radius = 10,
})
bk_game.register_tree("pine", {
	description = "Pine",
	leaves = trees.gen_lists.pine,
	height = function()
		return 13 + math.random(4)
	end,
	radius = 8,
})
bk_game.register_tree("spruce", {
	description = "Spruce",
	leaves = trees.gen_lists.spruce,
	height = function()
		return 10 + math.random(4)
	end,
})
