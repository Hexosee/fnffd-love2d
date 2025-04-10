local state = {}

local midi = require("lib.midiclock")
local paths = require("lib.paths")
local coolshit = require("lib.coolshit")
local tick = 0
local lasttick = 0
local part = 0

local bwords = nil

function state:enter()
    midi.song = Assets["mus_menu"]
    Assets["mus_menu"]:setLooping(true)
    midi.bpm = 110
    midi.song:play()

    math.randomseed(os.time())

    local lines = {}
    for line in love.filesystem.lines(paths.data("bwords.txt")) do
        table.insert(lines,line)
        math.random()
    end

    bwords = coolshit.split(lines[math.random(1,#lines)],"//")

end

function state:update()
    midi.update()

    if midi.div_4_trigger == true then
        tick=tick+1
    end

    if (tick == 1 or tick == 3 or tick == 5 or tick == 7 or tick == 9 or tick == 11 or tick == 13 or tick == 15 or tick == 16 or tick == 17) and tick ~= lasttick then
        part=part+1

        if part == 4 then
            love.audio.play(Assets["snd_gunkayy"])
        end

        if part == 10 then
            midi.song:stop()
            Gamestate.switch(States.title,midi.song,midi.song:tell("seconds"))
        end

    end

    lasttick = tick

end

function state:keypressed(key)
    if key == "return" then -- ITS CALLED ENTER YOU IDIOT
        midi.song:stop()
        Gamestate.switch(States.title,midi.song,midi.song:tell("seconds"))
    end
end

function state:draw()
    local textofs = 5
    love.graphics.setFont(Assets["fnt_comic1"])
    if part == 1 then
        love.graphics.printf("HEXOSE",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 2 then
        love.graphics.printf("PRESENT",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 3 then
        love.graphics.printf("IN ASSOCIATION WITH",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 4 then
        love.graphics.printf("IN ASSOCIATION WITH",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.draw(Assets["spr_love2d"],50,380,0,4,4)
        love.graphics.draw(Assets["spr_youtube"],430,380,0,4,4)
    elseif part == 5 then
        love.graphics.printf(bwords[1],textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 6 then
        love.graphics.printf(bwords[1],textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.printf(bwords[2],textofs,350,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 7 then
        love.graphics.printf("FNFFD",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 8 then
        love.graphics.printf("FNFFD",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.printf("LOVE2D",textofs,350,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 9 then
        love.graphics.printf("FNFFD",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.printf("LOVE2D",textofs,350,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.printf("PORT",textofs,420,love.graphics.getWidth()/4,"center",0,4,4)
    end
end

return state