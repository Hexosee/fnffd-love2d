Gamestate = require("lib.hump.gamestate")
States = {}
Assets = {}

Settings = {
    downscroll = false,
    binds = {"s","d","k","l"} -- my fucked up keybinds

}

local paths = require("lib.paths")
local coolshit = require("lib.coolshit")
local okaygo = 0
local gone = false
local loaded = false

local function init()
    States["recordsratch"] = require("states.recordsratch")
    States["bwords"] = require("states.bwords")
    States["title"] = require("states.title")
    States["selectwords"] = require("states.selectwords")
    States["freeplay"] = require("states.freeplay")
    States["stage"] = require("states.stage")

    -- load everything at the start of the game! juuust like dx...
    -- what could possibly go wrong!

    -- sprites
    Assets["spr_bing"] = love.graphics.newImage(paths.image("spr_bing"))

    Assets["spr_youtube"] = love.graphics.newImage(paths.image("bwords/spr_youtube"))
    Assets["spr_love2d"] = love.graphics.newImage(paths.image("bwords/spr_love2d"))

    Assets["spr_title_0"] = love.graphics.newImage(paths.image("title/spr_title_0"))
    Assets["spr_title_1"] = love.graphics.newImage(paths.image("title/spr_title_1"))

    Assets["spr_menugf"] = coolshit.makeAnim(love.graphics.newImage(paths.image("title/spr_menugf")),200,200,0.2,9)
    Assets["spr_menugfyeah"] = love.graphics.newImage(paths.image("title/spr_menugfyeah"))
    Assets["spr_menubacksg"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("spr_menubacksg")),400,480)

    Assets["spr_freeplayicons"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("freeplay/spr_freeplayicons")),149,149)

    Assets["spr_titlewords"] = love.graphics.newImage(paths.image("title/spr_titlewords"))

    Assets["spr_titlewords2"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("selectwords/spr_titlewords2")),222,222)

    Assets["spr_uinotes"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("game/spr_uinotes")),45,48)
    Assets["spr_notes"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("game/spr_notes")),45,48)

    -- fonts
    --Assets["fnt_comic1"] = love.graphics.newFont(paths.font("fnt_comic1"),8,"normal")
    Assets["fnt_comic1"] = love.graphics.newImageFont(paths.image("fnt_comic1")," !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~∎")

    -- music
    Assets["mus_menu"] = love.audio.newSource(paths.audio("mus/mus_menu"),"static")
    Assets["mus_tutorial"] = love.audio.newSource(paths.audio("mus/mus_tutorial"),"static")
    Assets["mus_w1s1"] = love.audio.newSource(paths.audio("mus/mus_w1s1"),"static")
    Assets["mus_w1s2"] = love.audio.newSource(paths.audio("mus/mus_w1s2"),"static")

    -- sfx
    Assets["snd_recordscratch"] = love.audio.newSource(paths.audio("snd/snd_recordscratch"),"static")
    Assets["snd_gunkayy"] = love.audio.newSource(paths.audio("snd/snd_gunkayy"),"static")
    Assets["snd_josh"] = love.audio.newSource(paths.audio("snd/snd_josh"),"static") -- doodledip!

    Gamestate.registerEvents()
    Gamestate.switch(States.recordsratch)
    loaded = true
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1) -- enable good mode
    Assets["spr_hey"] = love.graphics.newImage(paths.image("spr_hey"))
end

function love.update()
    okaygo=okaygo+1
    if okaygo>2 and not gone then
        init()
        gone = true
    end
end

function love.draw()
    if not loaded then
        love.graphics.rectangle("fill",0,0,800,800)
        love.graphics.draw(Assets["spr_hey"],400,400,0,3,3,Assets["spr_hey"]:getWidth()/2,Assets["spr_hey"]:getHeight()/2)
    end
end
