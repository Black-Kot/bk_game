bk_game = {}

function bk_game.register_stair(name, def)
	local name = name:remove_modname_prefix()
	minetest.register_node(":blocks:"..name.."_stair", {
		description = def.description.." Stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			if p0.y-1 == p1.y then
				local fakestack = ItemStack("blocks:"..name.."_stair_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})
	
	minetest.register_node(":blocks:"..name.."_stair_upside_down", {
		drop = "blocks:"..name.."_stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, 0, 0.5, 0, 0.5},
			},
		},
	})
	if def.without_craft == true then
		
	else
	minetest.register_craft({
		output = 'blocks:'..name..'_stair 8',
		recipe = {
			{def.source, "", ""},
			{def.source, def.source, ""},
			{def.source, def.source, def.source},
		},
	})

	-- Flipped recipe for the silly minecrafters
	minetest.register_craft({
		output = 'blocks:'..name..'_stair 8',
		recipe = {
			{"", "", def.source},
			{"", def.source, def.source},
			{def.source, def.source, def.source},
		},
	})
	end
end

function bk_game.register_slab(name, def)
	
	minetest.register_node(":blocks:"..name.."_slab",{
		description = def.description.." Slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		sunlight_propagates = def.sunlight_propagates,
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			-- If it's being placed on an another similar one, replace it with
			-- a full block
			local slabpos = nil
			local slabnode = nil
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local n0 = minetest.get_node(p0)
			if n0.name == "blocks:"..name.."_slab" and
					p0.y+1 == p1.y then
				slabpos = p0
				slabnode = n0
			end
			--[[if slabpos then
					minetest.remove_node(p0)
					itemstack:take_item(1)
					minetest.set_node(p0,{name=name})
				return itemstack
			end]]--
			-- Upside down slabs
			if p0.y-1 == p1.y then
				-- Turn into full block if pointing at a existing slab
				--[[if n0.name == "blocks:"..name.."_slab_upside_down" or "blocks:"..name.."_slab_upside_down" then
					minetest.remove_node(p0)
					itemstack:take_item(1)
					minetest.set_node(p0,{name=name})
				end]]--
				
				-- Place upside down slab
				local fakestack = ItemStack("blocks:"..name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			-- If pointing at the side of a upside down slab
			if n0.name == "blocks:"..name.."_slab_upside_down" and
					p0.y+1 ~= p1.y then
				-- Place upside down slab
				local fakestack = ItemStack("blocks"..name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})
	
	minetest.register_node(":blocks:"..name.."_slab_upside_down", {
		drop = "blocks:"..name.."_slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
		},
	})
	if def.without_craft == true then
		
	else
	minetest.register_craft({
		output = 'blocks:'..name..'_slab 6',
		recipe = {
			{def.source, def.source, def.source},
		},
	})
	end
end

function bk_game.register_column(name, def)

	minetest.register_node(":blocks:"..name.."_column", {
		description = def.description.." Column",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
		tiles = {"blocks_"..name..".png"},
		particle_image = {"blocks_"..name..".png"},
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = "blocks:"..name.."_column",
		recipe = {
			{"",def.source,""},
			{def.source,def.source,def.source},
			{"",def.source,""},
		}
	})

end

function bk_game.register_pyramid(name, def)

	minetest.register_node(":blocks:"..name.."_pyramid", {
		description = def.description.." Pyramid",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
				{-0.4, -0.3, -0.4, 0.4, -0.1, 0.4},
				{-0.3, -0.1, -0.3, 0.3, 0.1, 0.3},
				{-0.2, 0.1, -0.2, 0.2, 0.3, 0.2},
				{-0.1, 0.3, -0.1, 0.1, 0.5, 0.1},
			},
		},
	tiles = {"blocks_"..name..".png"},
	particle_image = {"blocks_"..name..".png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = "blocks:"..name.."_pyramid",
		recipe = {
			{"",def.source,""},
			{def.source,def.source,def.source},
		}
	})

end

function bk_game.register_nodes(name, def)
	
	if not def.tiles then
		def.tiles = {"blocks_"..name..".png"}
	end
	
	if not def.sounds then
		def.sounds = default.node_sound_stone_defaults()
	end
	
	if not def.groups then
		def.groups = {cracky=1, stone=1}
		def.is_ground_content = true
	end
	
	
	
	if not def.source then
		local source = "blocks:"..name
		def.source = source
	else
		if not def.drop then
			def.drop = "blocks:"..name
			def.legacy_mineral = true
		end
		minetest.register_craft({
			output = "blocks:"..name,
			recipe = {
				{def.source, def.source, ""},
				{def.source, def.source, ""}, 
			}
		})
	end
	
	minetest.register_node(":blocks:"..name, def)
	
	if def.slab == true then
		bk_game.register_slab(name, def)
	end
	
	if def.stair == true then
		bk_game.register_stair(name, def)
	end
	
	if def.column == true then
		bk_game.register_column(name, def)
	end
	
	if def.pyramid == true then
		bk_game.register_pyramid(name, def)
	end
end
