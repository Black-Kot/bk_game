bk_game = {}
bk_game.groups = {}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/helper_functions.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/groups.lua")

-- change stack_max globally
core.nodedef_default.stack_max = 100
core.craftitemdef_default.stack_max = 100
core.noneitemdef_default.stack_max = 100
