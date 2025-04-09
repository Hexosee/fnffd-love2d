local stage = {}

stage.campos = {

    badguy = {0,0},
    lady = {0,0},
    player = {0,0},

}

stage.charpos = {

    badguy = {4200,410},
    lady = {4550,370},
    player = {4900,400},
    
}
local paths = require("lib.paths")
local video = love.graphics.newVideo(paths.video("misplaced"),{audio=true})
local vidsource = video:getSource()
vidsource:setVolume(0)


function stage:update()
    if not video:isPlaying() then
        video:play()
    else
        vidsource:seek(Assets["mus_misplaced"]:tell("seconds"),"seconds")
    end
end

function stage:draw(cx,cy)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",-800,-800,800*2,800*2)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(video, 0, 0,0,0.7,0.7,1920/2,1080/2) -- this really needs to be compressed but i dont care sorry
end

function stage:event(event)
    
end

return stage