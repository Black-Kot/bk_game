bk_game.registered_trees = {}
bk_game.registered_trees_list = {}
function contains(t, v)
	for _, i in ipairs(t) do
		if i == v then
			return true
		end
	end
	return false
end
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
	}
	if TreeDef.gen_autumn_leaves then
		tree.gen_autumn_leaves = true
	end
	if TreeDef.gen_winter_leaves then
		tree.gen_winter_leaves = true
	end
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	tree.textures.trunk = tree.textures.trunk or {name_.."_trunk_top.png", name_.."_trunk_top.png", name_.."_trunk.png"}
	tree.textures.leaves = tree.textures.leaves or name_.."_leaves.png"
	tree.textures.autumn_leaves = tree.textures.autumn_leaves or name_.."_autumn_leaves.png"
	tree.textures.winter_leaves = tree.textures.winter_leaves or name_.."_winter_leaves.png"
	tree.textures.planks = tree.textures.planks or name_.."_planks.png"
	tree.textures.stick = tree.textures.stick or name_.."_stick.png"
	tree.textures.sapling = tree.textures.sapling or name_.."_sapling.png"
	tree.textures.log = tree.textures.log or name_.."_log.png"
	tree.textures.plank = tree.textures.plank or name_.."_plank.png"
	tree.textures.ladder = tree.textures.ladder or name_.."_ladder.png"
	tree.textures.chest = tree.textures.chest or {name_.."_chest_top.png", name_.."_chest_top.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_front.png"}
	tree.textures.locked_chest = tree.textures.locked_chest or {name_.."_chest_top.png", name_.."_chest_top.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_lock.png"}

	bk_game.registered_trees[name] = tree
	table.insert(bk_game.registered_trees_list, tree.name)

	minetest.register_craftitem(tree.name.."_plank", {
		description = tree.description.." Plank",
		inventory_image = tree.textures.plank,
		group = {plank=1, wood=1},
	})

<<<<<<< HEAD
=======
	bk_game.register_nodes(tree.name:remove_modname_prefix().."_planks", {
		source = tree.name.."_plank",
		slab=true,
		stair=true,
		description = tree.description.." Planks",
		block_tiles = {tree.textures.planks},
		groups = {planks=1,snappy=5,choppy=5,oddly_breakable_by_hand=2,flammable=3,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
	})

	bk_game.register_door(tree.name:remove_modname_prefix(), {
		source = tree.name.."_plank",
		description = tree.description,
		default_texture = tree.textures.planks,
	})

>>>>>>> 1e9afc47e2805f023d9e48d8374d5fa583f2e482
	minetest.register_craftitem(tree.name.."_stick", {
		description = tree.description.." Stick",
		inventory_image = tree.textures.stick,
		groups = {stick=1},
	})

	minetest.register_node(tree.name.."_sapling", {
		description = tree.description.." Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = {tree.textures.sapling},
		inventory_image = tree.textures.sapling,
		wield_image = tree.textures.sapling,
		paramtype = "light",
		walkable = false,
		falling_node_walkable = false,
		groups = {snappy=6,dig_immediate=3,flammable=2,dropping_node=1},
		sounds = default.node_sound_defaults()
	})


	minetest.register_node(tree.name.."_log", {
		description = tree.description.." Log",
		tiles = tree.textures.trunk,
		inventory_image = tree.textures.log,
		wield_image = tree.textures.log,
		groups = {log=1,choppy=5,snappy=5,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_plank 4",
		--drop_on_dropping = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
	})

	minetest.register_node(tree.name.."_leaves", {
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
					items = {tree.name.."_sapling"},
					rarity = 30,
				},
				{
					items = {tree.name.."_stick"},
					rarity = 10,
				},
				{
					items = {},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		falling_node_walkable = false,
		climbable = true,
	})

	if tree.gen_autumn_leaves then
		minetest.register_node(tree.name.."_leaves_autumn", {
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
						items = {tree.name.."_sapling"},
						rarity = 30,
					},
					{
						items = {tree.name.."_stick"},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			falling_node_walkable = false,
			climbable = true,
		})
	end

	if tree.gen_winter_leaves then
		minetest.register_node(tree.name.."_leaves_winter", {
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
						items = {tree.name.."_stick"},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			falling_node_walkable = false,
			climbable = true,
		})
	end

	minetest.register_node(tree.name.."_trunk", {
		description = tree.description.." Trunk",
		tiles = tree.textures.trunk,
		groups = {tree=1,choppy=5,snappy=5,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
	})

	minetest.register_node(tree.name.."_trunk_top", {
		tiles = tree.textures.trunk,
		groups = {tree=1,choppy=5,snappy=5,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			for i = 1,#tree.leaves do
				local p = {x=pos.x+tree.leaves[i][1], y=pos.y+tree.leaves[i][2], z=pos.z+tree.leaves[i][3]}
				if minetest.env:get_node(p).name == tree.name.."_leaves" then
					local drop = minetest.get_node_drops(minetest.get_node(p).name)
					minetest.env:dig_node(p)
					for _,item in ipairs(drop) do
						minetest.add_item(p, item)
					end
				end
			end
		end,
	})

	bk_game.register_nodes(tree.name:remove_modname_prefix().."_planks", {
		source = tree.name.."_plank",
		slab=true,
		stair=true,
		description = tree.description.." Planks",
		tiles = {tree.textures.planks},
		groups = {planks=1,snappy=5,choppy=5,oddly_breakable_by_hand=2,flammable=3,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
	})
	
	TreeDef.source = tree.name.."_plank"
	TreeDef.stair = true
	TreeDef.slab = true
	TreeDef.column = false
	TreeDef.pyramid = false
	bk_game.register_chest(name:remove_modname_prefix(), TreeDef)

	TreeDef.source =  tree.name.."_stick"
	bk_game.register_ladder(name:remove_modname_prefix(),TreeDef)

	bk_game.register_door(tree.name:remove_modname_prefix(), {
		source = tree.name.."_plank",
		description = tree.description,
		main_texture = tree.textures.planks,
	})

	minetest.register_abm({
		nodenames = {tree.name.."_sapling"},
		neighbors = tree.grounds,
		interval = tree.grow_interval,
		chance = tree.grow_chance,
		action = function(pos, node)
			if not minetest.env:get_node_light(pos) then
				return
			end
			if minetest.env:get_node_light(pos) >= tree.grow_light then
				trees.make_tree(pos, tree.name)
			end
		end,
	})
	
	minetest.register_abm({
		nodenames = {tree.name.."_trunk",tree.name.."_trunk_top"},
		interval = 0.2,
		chance = 1,
		action = function(pos, node)
			n_pos = {x=pos.x,y=pos.y-1,z=pos.z}
			n_node = minetest.get_node(n_pos)
			if n_node.name == "air" then
				minetest.dig_node(pos)
				-- drop
				minetest.add_item(pos, tree.name.."_log")
			end
		end,
	})
end

bk_game.register_tree("trees:ash", {
	description = "Ash",
	leaves = trees.gen_lists.ash,
	height = function()
		return 4 + math.random(4)
	end,
})
bk_game.register_tree("trees:aspen", {
	description = "Aspen",
	leaves = trees.gen_lists.aspen,
	height = function()
		return 10 + math.random(4)
	end,
})
bk_game.register_tree("trees:birch", {
	description = "Birch",
	leaves = trees.gen_lists.birch,
	height = function()
		return 10 + math.random(4)
	end,
})
bk_game.register_tree("trees:maple", {
	description = "Maple",
	leaves = trees.gen_lists.maple,
	height = function()
		return 7 + math.random(5)
	end,
})
bk_game.register_tree("trees:chestnut", {
	description = "Chestnut",
	leaves = trees.gen_lists.chestnut,
	height = function()
		return 9 + math.random(2)
	end,
	radius = 10,
})
bk_game.register_tree("trees:pine", {
	description = "Pine",
	leaves = trees.gen_lists.pine,
	height = function()
		return 13 + math.random(4)
	end,
	radius = 8,
})
bk_game.register_tree("trees:spruce", {
	description = "Spruce",
	leaves = trees.gen_lists.spruce,
	height = function()
		return 10 + math.random(4)
	end,
})
