registered_plants_list = {}

dofile(minetest.get_modpath("sea").."/coral.lua")
dofile(minetest.get_modpath("sea").."/grass.lua")
dofile(minetest.get_modpath("sea").."/kelp.lua")

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed + 114)
	local num = pr:next(1, 5)
	for ii=1,num,1 do
		local name = registered_plants_list[pr:next(1,#registered_plants_list)]
		if maxp.y < -30000 or minp.y > -8 then
			return
		end
		local perlin1 = minetest.get_perlin(329, 3, 0.6, 100)
		-- Assume X and Z lengths are equal
		local divlen = 16
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
			for divz=0,divs-1 do
				local x0 = minp.x + math.floor((divx+0)*divlen)
				local z0 = minp.z + math.floor((divz+0)*divlen)
				local x1 = minp.x + math.floor((divx+1)*divlen)
				local z1 = minp.z + math.floor((divz+1)*divlen)
				-- Determine plant amount from perlin noise
				local plant_amount = math.floor(perlin1:get2d({x=x0, y=z0}) * 5 + 0)
				-- Find random positions for plant based on this random
				for i=0,plant_amount do
					local x = pr:next(x0, x1)
					local z = pr:next(z0, z1)
					local ground_y = nil
					for y=maxp.y,minp.y,-1 do
						if table.contains({"default:dirt", "default:sand", "default:peat"}, minetest.get_node({x=x,y=y,z=z}).name) then
							ground_y = y
							break
						end
					end
					if ground_y then
						if pr:next(1, 15) == 1 then
							local pos = {x=x,y=ground_y+1, z=z}
							if string.match(minetest.get_node(pos).name, "water") then
								minetest.add_node(pos, {name = name})
							end
						end
					end
				end
			end
		end
	end
end)
