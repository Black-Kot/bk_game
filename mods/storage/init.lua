--[[
storage mod is a simple key-value storage that is used internally.

It contains three public functions (their purposes are obvious):
    bk_game.kv.set(key, value, mod)
        Returns `nil` if key isn't string or number
    bk_game.kv.get(key, mod)
        Returns saved value or `nil` if errors occur
    bk_game.kv.save()
        Returns `true` if all ok, `false` if errors occur

`key` MUST NOT be nil

If you want to remove object, call bk_game.kv.set(key, nil)

I don't recommend to save manually because it saves automatically every N seconds
--]]
bk_game.kv = {version=3}

-- TODO: use settings
local STORAGE_FILE = minetest.get_worldpath().."/storage"
local SAVE_INTERVAL = 10 -- seconds

-- May be useful for next versions
local storage = {VER=3}
local content_changed = false

local function load()
    local input = io.open(STORAGE_FILE, "r")
    if not input then return false end
    local file_content = input:read("*all")
    storage = minetest.deserialize(file_content)
    input:close()
end

function bk_game.kv.get(key, mod)
    local modname = minetest.get_current_modname() or mod or "storage"
    -- Create table for the mod if it doesn't exist
    if storage[modname] == nil then
        storage[modname] = {}
    end
    -- Prevent crash
    if key == nil then
        minetest.log("error", "In mod \""..modname.."\":")
        minetest.log("error", "bk_game.kv.get(): key must not be nil")
        return nil
    end
	return storage[modname][key]
end

function bk_game.kv.set(key, value, mod)
    local modname = minetest.get_current_modname() or mod or "storage"
    -- Create table for the mod if it doesn't exist
    if storage[modname] == nil then
        storage[modname] = {}
    end
    -- Prevent crash
    if key == nil then
        minetest.log("error", "In mod \""..modname.."\":")
        minetest.log("error", "bk_game.kv.set(): key must not be nil")
        return nil
    end
	storage[modname][key] = value
    content_changed = true
end

function bk_game.kv.save()
	local output = io.open(STORAGE_FILE, "w")
	if not output then return false end
	local content = minetest.serialize(storage)
    output:write(content)
    output:close()
    return true
end

load()

-- Trigger bk_game.kv.save() every SAVE_INTERVAL seconds
local timer_delta = 0
minetest.register_globalstep(function(dtime)
	timer_delta = timer_delta + dtime;
	if timer_delta >= SAVE_INTERVAL then
        if content_changed then
            bk_game.kv.save()
        end
		timer_delta = 0
	end
end)
