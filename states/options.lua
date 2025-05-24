local state = {}
state.name = "options"

local bitser = require("lib.bitser")
local coolshit = require("lib.coolshit")
--love.filesystem.write("options.swaws", bitser.dumps(Settings))
local sel = 0
local fade = coolshit.newFade("out",0.1,0,0,0)

local opts = {

    "DOWNSCROLL: false",
    "GHOST TAPPING: false",
    "UPDATE KEYBINDS",
    "NOTE TYPE: funny",
    "CHANGE SKIN" -- :eyes:

}


function state:update()
    fade:update()
end

function state:keypressed(key)
    if key == "up" then
        sel=sel-1
    end
    if key == "down" then
        sel=sel+1
    end
    if key == "return" then -- ITS. CALLED. ENTER.
        if sel == 2 then
            fade = coolshit.newFade("in",0.1,0,0,0)
            fade:setOnFinished(function()
                Gamestate.switch(States.freeplay)
            end)
        end
        --Gamestate.switch(States.stage,"mus_tutorial")
    end
    sel = coolshit.clamp(sel,1,#opts)
end

function state:draw()
    fade:update()
end

return state