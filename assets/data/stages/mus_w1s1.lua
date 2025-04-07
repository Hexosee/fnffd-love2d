local stage = {}

stage.campos = {

    badguy = {250,200},
    lady = {550,200},
    player = {850,200},

}

stage.charpos = {

    badguy = {200,410},
    lady = {550,370},
    player = {900,400},
    
}

function stage:update()
    
end

function stage:draw(cx,cy)
    love.graphics.setColor(145/255,207/255,221/255)
    love.graphics.rectangle("fill",-200,-400,love.graphics.getWidth()*2,love.graphics.getHeight()*2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Assets["spr_houseback2"],-570+cx/2,-100,0,2,2)
    love.graphics.draw(Assets["spr_houseback1"],-300,-100,0,2,2)
end

function stage:event(event)
    
end

return stage