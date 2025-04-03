local coolshit = require "lib.coolshit"
local state = {}

local lerpy = 0
local sel = 1

local fade = coolshit.newFade("out",0.1,0,0,0)

function state:update()
    fade:update()
    lerpy = coolshit.lerp(lerpy,sel*-120,0.2)
end

function state:draw()
    Assets["spr_menubacksg"]:draw(0,lerpy,2,0,4,4)
    Assets["spr_titlewords2"]:draw(-50,-30,sel,0,4,4) -- thank you tyler

    fade:draw()
end

function state:keypressed(key)
    if key == "up" then
        sel=sel-1
    end
    if key == "down" then
        sel=sel+1
    end
    if key == "return" then -- ITS. CALLED. ENTER.
        Gamestate.switch(States.stage,"mus_tutorial")
    end
    sel = coolshit.clamp(sel,1,4)
end

return state