bk_game = {}

dofile(minetest.get_modpath("utils").."/helper_functions.lua")

-- change max_stack globally
core.nodedef_default.stack_max = 100
core.craftitemdef_default.stack_max = 100
core.noneitemdef_default.stack_max = 100
