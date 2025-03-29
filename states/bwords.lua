local state = {}

state.name = "bwords"

local midi = require("lib.midiclock")

function state:enter()
    midi.song = Assets["mus_menu"]
    midi.bpm = 110
    midi.song:play()
end

function state:update()
    midi.update()
end

function state:draw()
    if midi.div_4_trigger then
        love.graphics.print("beeb",10,20)
    else
        love.graphics.print(":(",10,20)
    end
end

return state