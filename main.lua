Gamestate = require("lib.hump.gamestate")
States = {}
Assets = {}

local paths = require("lib.paths")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1) -- enable good mode

    States["recordsratch"] = require("states.recordsratch")
    States["bwords"] = require("states.bwords")

    -- load everything at the start of the game! juuust like dx...
    -- what could possibly go wrong!

    -- sprites
    Assets["spr_bing"] = love.graphics.newImage(paths.image("spr_bing"))

    -- music
    Assets["mus_menu"] = love.audio.newSource(paths.audio("mus_menu"),"static")

    -- sfx
    Assets["snd_recordscratch"] = love.audio.newSource(paths.audio("snd_recordscratch"),"static")

    Gamestate.registerEvents()
    Gamestate.switch(States.recordsratch)
end

function love.draw()
    love.graphics.print(Gamestate.current().name,10,10)
end