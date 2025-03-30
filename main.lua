Gamestate = require("lib.hump.gamestate")
States = {}
Assets = {}

local paths = require("lib.paths")
local coolshit = require("lib.coolshit")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1) -- enable good mode

    States["recordsratch"] = require("states.recordsratch")
    States["bwords"] = require("states.bwords")
    States["title"] = require("states.title")

    -- load everything at the start of the game! juuust like dx...
    -- what could possibly go wrong!

    -- sprites
    Assets["spr_bing"] = love.graphics.newImage(paths.image("spr_bing"))

    Assets["spr_youtube"] = love.graphics.newImage(paths.image("bwords/spr_youtube"))
    Assets["spr_love2d"] = love.graphics.newImage(paths.image("bwords/spr_love2d"))

    Assets["spr_title_0"] = love.graphics.newImage(paths.image("title/spr_title_0"))
    Assets["spr_title_1"] = love.graphics.newImage(paths.image("title/spr_title_1"))

    Assets["spr_menugf"] = coolshit.makeAnim(love.graphics.newImage(paths.image("title/spr_menugf")),200,200,0.05,9)
    Assets["spr_menugfyeah"] = love.graphics.newImage(paths.image("title/spr_menugfyeah"))
    Assets["spr_menuback"] = love.graphics.newImage(paths.image("spr_menuback"))
    Assets["spr_titlewords"] = love.graphics.newImage(paths.image("title/spr_titlewords"))

    -- fonts
    Assets["fnt_comic1"] = love.graphics.newFont(paths.font("fnt_comic1"),14,"normal") -- may replace with an imagefont later on..

    -- music
    Assets["mus_menu"] = love.audio.newSource(paths.audio("mus_menu"),"static")

    -- sfx
    Assets["snd_recordscratch"] = love.audio.newSource(paths.audio("snd_recordscratch"),"static")
    Assets["snd_gunkayy"] = love.audio.newSource(paths.audio("snd_gunkayy"),"static")
    Assets["snd_josh"] = love.audio.newSource(paths.audio("snd_josh"),"static") -- doodledip!

    Gamestate.registerEvents()
    Gamestate.switch(States.recordsratch)
end

function love.draw()
    print("WOOO!")
    if Gamestate.current().name ~= nil then
        love.graphics.print(Gamestate.current().name,10,10)
    else
        love.graphics.print("name your state you moron",10,10)
    end
end