doors = {}

-- Registers a door
--  name: The name of the door
--  def: a table with the folowing fields:
--    description
--    inventory_image
--    groups
--    tiles_bottom: the tiles of the bottom part of the door {front, side}
--    tiles_top: the tiles of the bottom part of the door {front, side}
--    If the following fields are not defined the default values are used
--    node_box_bottom
--    node_box_top
--    selection_box_bottom
--    selection_box_top
--    only_placer_can_open: if true only the player who placed the door can
--                          open it

minetest.register_privilege("doors", {
	description = "Player can open locked doors.",
	give_to_singleplayer = false,
})


function bk_game.register_door(name, def)

	local box = {{-0.5, -0.5, -0.5,   0.5, 0.5, -0.5+1.5/16}}

	minetest.register_craftitem(":doors:"..name, {
		description = def.description.." Door",
		inventory_image = "doors_"..name..".png",

		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end

			local ptu = pointed_thing.under
			local nu = minetest.get_node(ptu)
			if minetest.registered_nodes[nu.name].on_rightclick then
				return minetest.registered_nodes[nu.name].on_rightclick(ptu, nu, placer, itemstack)
			end

			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			if
				not minetest.registered_nodes[minetest.get_node(pt).name].buildable_to or
				not minetest.registered_nodes[minetest.get_node(pt2).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end

			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end
			if not string.find(minetest.get_node(pt3).name, "doors:"..name.."_b_") then
				minetest.set_node(pt, {name="doors:"..name.."_b_1", param2=p2})
				minetest.set_node(pt2, {name="doors:"..name.."_t_1", param2=p2})
			else
				minetest.set_node(pt, {name="doors:"..name.."_b_2", param2=p2})
				minetest.set_node(pt2, {name="doors:"..name.."_t_2", param2=p2})
			end

			if def.only_placer_can_open then
				local pn = placer:get_player_name()
				local meta = minetest.get_meta(pt)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
				meta = minetest.get_meta(pt2)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
			end

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	local tt = {"doors_"..name.."_a.png", def.default_texture}
	local tb = {"doors_"..name.."_b.png", def.default_texture}

	local function after_dig_node(pos, name)
		if minetest.get_node(pos).name == name then
			minetest.remove_node(pos)
		end
	end

	local function on_rightclick(pos, dir, check_name, replace, replace_dir, params)
		pos.y = pos.y+dir
		if not minetest.get_node(pos).name == check_name then
			return
		end
		local p2 = minetest.get_node(pos).param2
		p2 = params[p2+1]

		local meta = minetest.get_meta(pos):to_table()
		minetest.set_node(pos, {name=replace_dir, param2=p2})
		minetest.get_meta(pos):from_table(meta)

		pos.y = pos.y-dir
		meta = minetest.get_meta(pos):to_table()
		minetest.set_node(pos, {name=replace, param2=p2})
		minetest.get_meta(pos):from_table(meta)
	end

	local function check_player_priv(pos, player)
		if not def.only_placer_can_open then
			return true
		end
		local meta = minetest.get_meta(pos)
		local pn = player:get_player_name()
		return meta:get_string("doors_owner") == pn or minetest.check_player_privs(player:get_player_name(), {doors=true}) == true
	end

	minetest.register_node(":doors:"..name.."_b_1", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1], tb[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "doors:"..name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = box
		},
		selection_box = {
			type = "fixed",
			fixed = box
		},
		groups = {snappy=6,bendy=6,cracky=6,oddly_breakable_by_hand=2,melty=2,level=2,door=1,not_in_creative_inventory = 1},

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, "doors:"..name.."_t_1")
		end,

		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, 1, "doors:"..name.."_t_1", "doors:"..name.."_b_2", "doors:"..name.."_t_2", {1,2,3,0})
			end
		end,

		can_dig = check_player_priv,
	})

	minetest.register_node(":doors:"..name.."_t_1", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "doors:"..name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = box
		},
		selection_box = {
			type = "fixed",
			fixed = box
		},
		groups = {snappy=6,bendy=6,cracky=6,oddly_breakable_by_hand=2,melty=2,level=2,door=1,not_in_creative_inventory = 1},

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, "doors:"..name.."_b_1")
		end,

		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, -1, "doors:"..name.."_b_1", "doors:"..name.."_t_2", "doors:"..name.."_b_2", {1,2,3,0})
			end
		end,

		can_dig = check_player_priv,
	})

	minetest.register_node(":doors:"..name.."_b_2", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1].."^[transformfx", tb[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "doors:"..name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = box
		},
		selection_box = {
			type = "fixed",
			fixed = box
		},
		groups = {snappy=6,bendy=6,cracky=6,oddly_breakable_by_hand=2,melty=2,level=2,door=1,not_in_creative_inventory = 1},

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, "doors:"..name.."_t_2")
		end,

		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, 1, "doors:"..name.."_t_2", "doors:"..name.."_b_1", "doors:"..name.."_t_1", {3,0,1,2})
			end
		end,

		can_dig = check_player_priv,
	})

	minetest.register_node(":doors:"..name.."_t_2", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1].."^[transformfx", tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "doors:"..name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = box
		},
		selection_box = {
			type = "fixed",
			fixed = box
		},
		groups = {snappy=6,bendy=6,cracky=6,oddly_breakable_by_hand=2,melty=2,level=2,door=1,not_in_creative_inventory = 1},

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, "doors:"..name.."_b_2")
		end,

		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, -1, "doors:"..name.."_b_2", "doors:"..name.."_t_1", "doors:"..name.."_b_1", {3,0,1,2})
			end
		end,

		can_dig = check_player_priv,
	})

	minetest.register_craft({
	output = "doors:"..name,
	recipe = {
		{def.source, def.source},
		{def.source, def.source},
		{def.source, def.source}
	}
})
end
