local state = {}

state.name = "bwords"

local midi = require("lib.midiclock")
local tick = 0
local lasttick = 0
local part = 0

function state:enter()
    midi.song = Assets["mus_menu"]
    Assets["mus_menu"]:setLooping(true)
    midi.bpm = 110
    midi.song:play()
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
        love.graphics.printf("sorry kayla",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
    elseif part == 6 then
        love.graphics.printf("sorry kayla",textofs,280,love.graphics.getWidth()/4,"center",0,4,4)
        love.graphics.printf("i stole your font",textofs,350,love.graphics.getWidth()/4,"center",0,4,4)
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

    if midi.div_4_trigger then
        love.graphics.print("peeb!",10,50)
    end
    love.graphics.print(midi.song:tell("seconds"),10,100)
    love.graphics.print(part,10,25)
end

return state