minetest.register_privilege("chest", {
	description = "Player can open locked chests.",
	give_to_singleplayer= false,
})



default.chest_formspec = 
	"invsize[12,9;]"..
	"list[current_name;main;0,0;12,5;]"..
	"list[current_player;main;0,5;8,4;]"

function default.get_locked_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"invsize[12,9;]"..
		"list[nodemeta:".. spos .. ";main;0,0;12,5;]"..
		"list[current_player;main;0,5;8,4;]"
	return formspec
end

function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner")  then
		if minetest.check_player_privs(player:get_player_name(), {chest=true}) ~= true then
			return false
		end
	end
	return true
end


function bk_game.register_chest(name, def) 

minetest.register_craft({
	output = 'chest:'..name,
	recipe = {
		{def.source, def.source, def.source},
		{def.source, '', def.source},
		{def.source, def.source, def.source},
	}
})

minetest.register_craft({
	output = 'chest:'..name..'_locked',
	recipe = {
		{def.source, def.source, def.source},
		{def.source, 'metals:steel_ingot', def.source},
		{def.source, def.source, def.source},
	}
})


minetest.register_craft({
	output = 'chest:'..name..'_locked',
	recipe = {
		{ 'chest:'..name, 'metals:steel_ingot', ''},
	}
})

minetest.register_node(":chest:"..name, {
	description = def.description.." Chest",
	tiles = {"chest_"..name.."_top.png", "chest_"..name.."_top.png", "chest_"..name.."_side.png",
		"chest_"..name.."_side.png", "chest_"..name.."_side.png", "chest_"..name.."_front.png"},
	paramtype2 = "facedir",
	groups = {choppy=def.level,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",default.chest_formspec)
		meta:set_string("infotext", def.description.." Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*5)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_node(":chest:"..name.."_locked", {
	description = def.description.." Locked Chest",
	tiles = {"chest_"..name.."_top.png", "chest_"..name.."_top.png", "chest_"..name.."_side.png", "chest_"..name.."_side.png", "chest_"..name.."_side.png", "chest_"..name.."_locked.png"},
	paramtype2 = "facedir",
	groups = {choppy=def.level,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked "..def.description.." Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*5)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_locked_chest_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from locked chest at "..minetest.pos_to_string(pos))
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if has_locked_chest_privilege(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"default:chest_locked",
				default.get_locked_chest_formspec(pos)
			)
		end
	end,
})

end
