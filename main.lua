Gamestate = require("lib.hump.gamestate")
States = {}
Assets = {}
Characters = {}

local bitser = require("lib.bitser")

Settings = {
    downscroll = false,
    binds = {"s","d","k","l"} -- my fucked up keybinds

}


if love.filesystem.getInfo("options.swaws") ~= nil then
    Settings = bitser.loads(love.filesystem.read("options.swaws"))
end


local paths = require("lib.paths")
local coolshit = require("lib.coolshit")
local okaygo = 0
local gone = false
local loaded = false

local function init()

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
    Assets["spr_countdown"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("game/spr_countdown")),200,200)

    -- stages
    Assets["spr_houseback1"] = love.graphics.newImage(paths.image("game/stages/mus_w1s1/spr_houseback1"))
    Assets["spr_houseback2"] = love.graphics.newImage(paths.image("game/stages/mus_w1s1/spr_houseback2"))


    Assets["spr_speaker"] = coolshit.makeAnimGM(love.graphics.newImage(paths.image("characters/lady/spr_speaker")),128,54)

    -- fonts
    --Assets["fnt_comic1"] = love.graphics.newFont(paths.font("fnt_comic1"),8,"normal")
    Assets["fnt_comic1"] = love.graphics.newImageFont(paths.image("fnt_comic1")," !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~∎")

    -- music
    for _,mus in ipairs(love.filesystem.getDirectoryItems("assets/audio/mus/")) do
        print("LOADING "..mus)
        Assets[string.gsub(mus,".ogg","")] = love.audio.newSource("assets/audio/mus/"..mus,"static")
    end

    -- sfx
    for _,sfx in ipairs(love.filesystem.getDirectoryItems("assets/audio/snd/")) do
        print("LOADING "..sfx)
        Assets[string.gsub(sfx,".ogg","")] = love.audio.newSource("assets/audio/snd/"..sfx,"static")
    end

    -- states! these used to be at the top but stage needs characters and i dont wanna clutter state:enter!
    for _,state in ipairs(love.filesystem.getDirectoryItems("states/")) do
        print("LOADING "..state)
        States[string.gsub(state,".lua","")] = love.filesystem.load("states/"..state)()
    end

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
