local state = {}

state.name = "title"

local coolshit = require("lib.coolshit")
local midi = require("lib.midiclock")
local scale = 0
local titlespr = "spr_title_0"

local switchtimer = 30
local byebye = false

local fade = coolshit.newFade("out",0.05,255,255,255)

function state:enter()
    if math.random(0,50) == 50 then
        titlespr = "spr_title_1"
    end
    midi.song = Assets["mus_menu"]
    midi.song:play()
    midi.song:seek(8.741,"seconds") -- was gonna feed this through with gamestate.switch but it keeps saying its userdata!
end

function state:update()
    midi:update()
    fade:update()
    Assets["spr_menugf"]:update()
    if midi.div_4_trigger then
        scale=0.2
        Assets["spr_menugf"]:bop()
    end
    scale=coolshit.lerp(scale,0,0.2)

    if byebye then
        if switchtimer < 0 then
            byebye = false
            fade = coolshit.newFade("in",0.1,0,0,0)
            fade:setOnFinished(function()
                Gamestate.switch(States.selectwords)
            end)
        end
        switchtimer = switchtimer - 1
    end

end

function state:keypressed(key)
    if key == "return" and not byebye then -- ITS CALLED ENTER YOU IDIOT
        byebye = true
        fade.alpha = 1
        love.audio.play(Assets["snd_josh"])
    end
end

function state:draw()
    if midi.div_4_trigger then
        love.graphics.print("peeb!",10,50)
    end
    Assets["spr_menubacksg"]:draw(0,0,1,0,4,4)
    love.graphics.draw(Assets[titlespr],love.graphics.getWidth()/2,190,0,4+scale,4+scale,Assets["spr_title_0"]:getWidth()/2,Assets["spr_title_0"]:getHeight()/2)
    if not byebye then
        Assets["spr_menugf"]:draw(love.graphics.getWidth()/2,love.graphics.getWidth(),0,4,4,Assets["spr_menugf"].width/2,Assets["spr_menugf"].height)
    else
        love.graphics.draw(Assets["spr_menugfyeah"],love.graphics.getWidth()/2,love.graphics.getWidth(),0,4,4,Assets["spr_menugfyeah"]:getWidth()/2,Assets["spr_menugfyeah"]:getHeight())
    end
    love.graphics.setColor(255,255,255,0.5)
    love.graphics.draw(Assets["spr_titlewords"],10,love.graphics.getHeight()-10,0,4,4,0,Assets["spr_titlewords"]:getHeight())
    love.graphics.setColor(255,255,255,math.abs(math.sin(love.timer.getTime()*2))) -- not accurate but i dont care
    love.graphics.draw(Assets["spr_titlewords"],10,love.graphics.getHeight()-10,0,4,4,0,Assets["spr_titlewords"]:getHeight())
    love.graphics.setColor(255,255,255,1)
    fade:draw()
end

return state