registered_ores = {}
registered_ores_list = {}

local d_seed = 0
  
function bk_game.register_ore(name, OreDef)
	local ore = {
		name = name,
		description = OreDef.description.." Ore" or "Ore",
		mineral = OreDef.mineral or "ores:"..name,
		wherein = OreDef.wherein or "blocks:stone",	
		chunks_per_volume = OreDef.chunks_per_volume or 1/3/3/3/2,	
		chunk_size = OreDef.chunk_size or 30,
		ore_per_chunk = OreDef.ore_per_chunk or 15*15*15,
		height_min = OreDef.height_min or -30912,
		height_max = OreDef.height_max or 30912,
		noise_min = OreDef.noise_min or 0.6,
		noise_max = OreDef.noise_max or nil,
		chunks_per_volume = 1,
		generate = true,
		delta_seed = OreDef.delta_seed or d_seed
	}
	print("Ore "..ore.description.." [OK]")
	d_seed = d_seed + 1
	if OreDef.generate == false then
		ore.generate = false
	end
	registered_ores[name] = ore
	table.insert(registered_ores_list, name)
	if not OreDef.no_node == true then
		local wherein_ = ore.wherein:gsub(":","_")
		local wherein_textures =  "ores_"..name..".png"
		local particle_image = wherein_..".png^"..wherein_textures
		minetest.register_node(":"..ore.mineral, {
			description = ore.description,
			tiles = {particle_image},
			particle_image = {particle_image},
			groups = {cracky = 4},
			drop = {
				max_items = 1,
				items = {
					{
						items = {OreDef.lump.." 2"},
						rarity = 2
					},
					{
						items = {OreDef.lump}
					}
				}
			},
			sounds = default.node_sound_stone_defaults()
		})
	end
end

minetest.register_node(":default:peat", {
	description = "Peat",
	tile_images = {"ores_peat.png"},
	particle_image = {"ores_peat.png"},
	groups = {crumbly=5,drop_on_dig=1,falling_node=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:peat",
	burntime = 15
})

local function generate_peat(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	if inverse_chance == 0 then
		inverse_chance = 1
	end
	--print("generate_ore num_chunks: "..dump(num_chunks))
	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.get_node(p2).name == wherein then
						if minetest.get_node({x=p2.x, y=p2.y + 1, z=p2.z}).name == "default:water_source" and
						minetest.get_node({x=p2.x, y=p2.y + 2, z=p2.z}).name == "air" then
							minetest.add_node(p2, {name=name})
						end
						if minetest.get_node({x=p2.x, y=p2.y + 1, z=p2.z}).name == "default:water_source" and
						minetest.get_node({x=p2.x, y=p2.y + 2, z=p2.z}).name == "default:water_source" and 
						minetest.get_node({x=p2.x, y=p2.y + 3, z=p2.z}).name == "air" then
							minetest.add_node(p2, {name=name})
						end
						
					end
				end
			end
			end
			end
		end
	end
end

local function is_node_beside(pos, node)
	local sides = {{x=-1,y=0,z=0}, {x=1,y=0,z=0}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=0,y=-1,z=0}, {x=0,y=1,z=0},}
	for i, s in ipairs(sides) do
		if minetest.get_node({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z}).name == node then
			return true, minetest.dir_to_wallmounted(s)
		end
	end
	return false
end


local function generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size,
	ore_per_chunk, height_min, height_max, noise_min, noise_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	--[[]
	local pr = PseudoRandom(seed)
	local pos1 = {x=0, y=0, z=0}
	pos1.x = pr:next(minp.x+10, maxp.x-10)
	pos1.y = pr:next(minp.y+10, maxp.y-10)
	pos1.z = pr:next(minp.z+10, maxp.z-10)
	print("pos setnodes("..name..") is: ("..pos1.x..","..pos1.y..","..pos1.z..")")
	local X1 = 10
	local Y1 = 10
	local Z1 = 10
	
	for x0 = 1, X1, 1 do 
		for y0 = 1, Y1, 1 do
			for z0 = 1, Z1, 1 do
				local p2 = {x=pos1.x+x0, y=pos1.y+y0, z=pos1.y+y0}
				
	print("pos setnodes("..name.." , in "..wherein.."?"..minetest.get_node(p2).name..") is: ("..p2.x..","..p2.y..","..p2.z..")")
					if minetest.get_node(p2).name == wherein then
							-- perlin
							if type(noise_min) == "number" or type(noise_max) == "number" then
								if ore_noise2 >= noise_min and ore_noise2 <= noise_max then
									minetest.add_node(p2, {name=name})
									print("setnode("..p2.x..","..p2.y..","..p2.z.." : "..name..")")
								end
							else
								minetest.add_node(p2, {name=name})
								print("setnode("..p2.x..","..p2.y..","..p2.z.." : "..name..")")
							end
							
					end
			end
		end
	end
			--]]	
			
	local ore_noise1
	local ore_noise2
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	if y_min > y_max-chunk_size then
		y_min = y_max-(chunk_size*2)
	end
	if minp.x > maxp.x-chunk_size then
		minp.x = maxp.x-(chunk_size*2)
	end
	if minp.z > maxp.z-chunk_size then
		minp.z = maxp.z-(chunk_size*2)
	end
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	if inverse_chance == 0 then
		inverse_chance = 1
	end
	-- perlin. Only done if borders are defined.
	if type(noise_min) == "number" or type(noise_max) == "number" then
		if type(noise_min) ~= "number" then
			noise_min = -2
		end
		if type(noise_max) ~= "number" then
			noise_max = 2
		end
		ore_noise1 = minetest.get_perlin(seed, 3, 0.7, 100)
	end
	
	for i=1,chunk_size + 1 do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			
			-- perlin
			if type(noise_min) == "number" or type(noise_max) == "number" then
				ore_noise2 = (ore_noise1:get3d(p0))
			end
			
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.get_node(p2).name == wherein then
							-- perlin
							if type(noise_min) == "number" or type(noise_max) == "number" then
								if ore_noise2 >= noise_min and ore_noise2 <= noise_max then
									minetest.add_node(p2, {name=name})
									--print("setnode("..p2.x..","..p2.y..","..p2.z.." : "..name..")")
								end
							else
								minetest.add_node(p2, {name=name})
								--print("setnode("..p2.x..","..p2.y..","..p2.z.." : "..name..")")
							end
							
					end
				end
			end
			end
			end
		end
	end
	--print("generate_perlinore node done")
end


minetest.after(1, function()
	minetest.register_on_generated(function(minp, maxp, seed)
		local pr = PseudoRandom(seed)
		local ore = registered_ores[registered_ores_list[pr:next(1,#registered_ores_list)]]
	
		--for __, wherein in ipairs(ore.wherein) do
			generate_ore(ore.mineral, ore.wherein, minp, maxp, seed+ore.delta_seed,
				ore.chunks_per_volume, ore.chunk_size,
				ore.ore_per_chunk, ore.height_min, ore.height_max, ore.noise_min, ore.noise_max)
		--end
		if pr:next(1,5)  == 3 then
			generate_peat("blocks:clay", "default:dirt", minp, maxp, seed+401, 1/8/16/24, 10, 1000, -100, 200)
		else
			generate_peat("default:peat", "default:dirt", minp, maxp, seed+401, 1/8/16/24, 10, 1000, -100, 200)
		end
	end)
end)


----------------------------------------------------------

-- oil

bk_game.register_ore("default:oil_source", {
	description = "Oil",
	mineral = "default:oil_source",
	wherein = "air",
	chunk_size = 16,
	height_max = -2000,
	no_node = true,
})
