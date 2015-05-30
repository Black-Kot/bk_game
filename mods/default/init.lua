-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt
WATER_ALPHA = 160
WATER_VISC = 1
OIL_ALPHA = 210
OIL_VISC = 16
LAVA_VISC = 7
LIGHT_MAX = 14
-- Definitions made by this mod that other mods can use too
default = {}

-- Styles
bk_game.style_bgcolor = "bgcolor[#080808AA;true]"
bk_game.style_slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

-- Load files
dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/player.lua")
