local state = {}
local bingtimer = 0

function state:enter()
    love.audio.play(Assets.snd_recordscratch)
end

function state:update(dt)
    bingtimer=bingtimer+1
    if bingtimer > 24 then
        Gamestate.switch(States.bwords)
    end
end

function state:draw()
    if bingtimer < 8 then
        love.graphics.draw(Assets.spr_bing,0,0,0,4,4)
    end
end

return state