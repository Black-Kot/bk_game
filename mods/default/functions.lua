-- mods/default/functions.lua

--
-- Sounds
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=0.25}
	table.place = table.place or
			{name="default_place_node_hard", gain=1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_hard_footstep", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_dirt_footstep", gain=1.0}
	table.dug = table.dug or
			{name="default_dirt_footstep", gain=1.5}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_sand_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_sand_footstep", gain=1.0}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_wood_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_wood_footstep", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.35}
	table.dug = table.dug or
			{name="default_grass_footstep", gain=0.85}
	table.dig = table.dig or
			{name="default_dig_crumbly", gain=0.4}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_glass_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_break_glass", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

--
-- Legacy
--

function default.spawn_falling_node(p, nodename)
	spawn_falling_node(p, nodename)
end

-- Horrible crap to support old code
-- Don"t use this and never do what this does, it"s completely wrong!
-- (More specifically, the client and the C++ code doesn"t get the group)
function default.register_falling_node(nodename, texture)
	minetest.log("error", debug.traceback())
	minetest.log("error", "WARNING: default.register_falling_node is deprecated")
	if minetest.registered_nodes[nodename] then
		minetest.registered_nodes[nodename].groups.falling_node = 1
	end
end

--
-- Global callbacks
--

-- Global environment step function
function on_step(dtime)
	-- print("on_step")
end
minetest.register_globalstep(on_step)

function on_placenode(p, node)
	--print("on_placenode")
end
minetest.register_on_placenode(on_placenode)

function on_dignode(p, node)
	--print("on_dignode")
end
minetest.register_on_dignode(on_dignode)

function on_punchnode(p, node)
end
minetest.register_on_punchnode(on_punchnode)

--
-- Lavacooling
--

default.cool_lava_source = function(pos)
	minetest.set_node(pos, {name="blocks:obsidian"})
	minetest.sound_play("default_cool_lava", {pos = pos,  gain = 0.25})
end

default.cool_lava_flowing = function(pos)
	minetest.set_node(pos, {name="blocks:stone"})
	minetest.sound_play("default_cool_lava", {pos = pos,  gain = 0.25})
end

minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		default.cool_lava_flowing(pos, node, active_object_count, active_object_count_wider)
	end,
})

minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		default.cool_lava_source(pos, node, active_object_count, active_object_count_wider)
	end,
})

--
-- Papyrus and cactus growing
--

minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if minetest.get_item_group(name, "sand") ~= 0 then
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:cactus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:cactus"})
				end
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"default:papyrus"},
	neighbors = {"default:dirt", "default:dirt_with_grass"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if name == "default:dirt" or name == "default:dirt_with_grass" then
			if minetest.find_node_near(pos, 3, {"group:water"}) == nil then
				return
			end
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:papyrus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:papyrus"})
				end
			end
		end
	end,
})
