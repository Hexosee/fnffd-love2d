-- every swows implementation i make is scuffed in some way :broken_heart:

local state = {}

local conduct = require("lib.game.conductor")
local paths = require("lib.paths")
local uinote = require("lib.game.uinote")
local note = require("lib.game.note")
local coolshit = require("lib.coolshit")
local midi = require("lib.midiclock")
local cam = require("lib.hump.camera")

local camera = cam(0,0)
camera:lookAt(0,0)

local conductor = conduct.Conductor()

local suckers = {}
local dinguses = {}

local ready = false

local notesurf = love.graphics.newCanvas(400,400)

local dosc,starty,syncfix

local fade = coolshit.newFade("out",0.1,0,0,0)

local chars = {
    badguy = Characters["strad"]:copy(),
    lady = Characters["lady"]:copy(),
    player = Characters["dude"]:copy(),
}

chars.lady.canReset = false

local camtarget = "lady"

local animlist = {

    [0]="left",
    [1]="down",
    [2]="up",
    [3]="right",

    [4]="leftalt",
    [5]="downalt",
    [6]="upalt",
    [7]="rightalt",

}

local speakerind = 1
local score, misses = 0, 0
local round = function(n)
	return math.floor(n + 0.5)
end

function state:enter(prev,rawsong)
    local song = Assets[rawsong]
    local path = paths.swows(rawsong)
    state.stage = require(paths.stage(rawsong))

    camera:lookAt(state.stage.campos.lady[1],state.stage.campos.lady[2])

    midi.song = song

    local lines = {}
    for line in love.filesystem.lines(path) do
        table.insert(lines,line)
    end

    table.remove(lines,1) -- sorry songname fans
    local bpm = lines[1]
    midi.bpm = bpm
    table.remove(lines,1)
    local notespeed = lines[1]
    table.remove(lines,1)
    table.remove(lines,1) -- skip keys variable (I AM NEVER ADDING MULTI KEY SUPPORT)

    -- var songlong=round(((audio_sound_length(obj_song.song)/60)*obj_song.bpm*4));
    -- 1361
    -- 145.82142639160156
    -- 72.78947845805
    local songlong = round( ((song:getDuration("seconds")/60) * bpm * 4))
    --local songlong = round((#lines) / 8)
    print("\nmy name songlong")
    print(songlong)
    print(song:getDuration("seconds"))

    -- should probably be a tenary operator but they just dont seem to work?? unless i'm dumb or somehting
    -- maybe its just a luau thing . i miss +=1...
    if Settings.downscroll then
        dosc = -1
        starty = 352
        syncfix = 0
    else
        dosc = 1
        starty = 48
        syncfix = 96
    end

    conductor.bpm = bpm
    conductor.notespeed = notespeed
    conductor.source = song

    -- its all chart here on out
    for bb=0,7,1 do
        local myx
        if bb < 4 then
            myx = 32+(44*bb)
        else
            myx = 234+(44*(bb-4))
        end
        local sucker = uinote:create(myx,starty,bb) -- thanks lua
        table.insert(suckers,sucker)
        -- note... notes 

        for b=0, songlong-1, 1 do
            if tonumber(lines[1]) ~= 0 then
                local dingus = note:create(myx,starty+(b*48*notespeed*dosc)+syncfix*dosc,bb)
                dingus.type = tonumber(lines[1])
                table.insert(dinguses,dingus)

            end
            table.remove(lines,1)
        end
    end

    love.audio.stop()
    song:play()
    ready = true
end

local function checkCollision(y,sucker,hitbox)
    return (y > sucker.y-hitbox and y < sucker.y+hitbox)
end

function state:update()
    fade:update()
    if not ready then return end
    midi:update()
    conductor:update()
    for _,sucker in ipairs(suckers) do
        sucker:update()
    end
    for i,dingus in ipairs(dinguses) do
        dingus:update(conductor.x,conductor.y*-dosc)
        if (dingus.y < -48 and not Settings.downscroll) or (dingus.y > 848 and Settings.downscroll) then
            table.remove(dinguses,i)
        end
        -- checkCollision(dingus.y,suckers[dingus.note+1]) and (suckers[dingus.note+1].note <= 3 or suckers[dingus.note+1].pressed)
        local sucker = suckers[dingus.note+1]

        if (sucker.note <= 3 and checkCollision(dingus.y,sucker,8)) then -- badguy
            table.remove(dinguses,i)
            if dingus.type == 1 or dingus.type == 2 or dingus.type == 8 or dingus.type == 9 then
                chars.badguy.curAnim = animlist[dingus.note]
                chars.badguy:bop()
            end
        end

        --[[
            * 1 = normal note
            * 2 = alt anim
            * 3 = bomb
            * 4 = dudecam
            * 5 = enemy cam
            * 6 = middle camera
            * 7 = ayy
            * 8 = hold
            * 9 = alt hold (?)
            * 10 = event           
        ]]

        if checkCollision(dingus.y,sucker,64) then -- goodguy ..
            if (dingus.type == 1 or dingus.type == 2) and sucker.hit then -- normal notes
                table.remove(dinguses,i)
                chars.player.curAnim = animlist[dingus.note-4]
                chars.player:bop()
                score=score + 100
            end

            if (dingus.type == 8 or dingus.type == 9) and checkCollision(dingus.y,sucker,16) and sucker.pressed then
                table.remove(dinguses,i)
                chars.player.curAnim = animlist[dingus.note-4]
                chars.player:bop()
                score=score + 25
            end
            

            if checkCollision(dingus.y,sucker,8) then
                if dingus.type == 4 then
                    camtarget = "player"
                    table.remove(dinguses,i)
                elseif dingus.type == 5 then
                    camtarget = "badguy"
                    table.remove(dinguses,i)
                elseif dingus.type == 6 then
                    camtarget = "lady"
                    table.remove(dinguses,i)
                end
            end
        end
        
    end
    
    chars.player:update()
    chars.lady:update()
    chars.badguy:update()

    if midi.div_4_trigger and chars.player.curAnim == "idle" then
        chars.player:bop()
    end

    if midi.div_4_trigger and chars.badguy.curAnim == "idle" then
        chars.badguy:bop()
    end

    if midi.div_4_trigger then
        if chars.lady.curAnim == "left" then
            chars.lady.curAnim = "right"
        else
            chars.lady.curAnim = "left"
        end
        chars.lady:bop()
        speakerind=speakerind+1
        if speakerind > 4 then
            speakerind=1
        end
    end

    camera:lookAt(
        coolshit.lerp(camera.x,state.stage.campos[camtarget][1],coolshit.d(0.15)),
        coolshit.lerp(camera.y,state.stage.campos[camtarget][2],coolshit.d(0.15))
    )

    state.stage:update()

end

function state:draw()
    if not ready then return end
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle("fill",0,0,800,800)
    love.graphics.setColor(1,1,1)

    love.graphics.setCanvas(notesurf)
        love.graphics.clear(0, 0, 0, 0)
        for _,sucker in ipairs(suckers) do
            sucker:draw()
        end
        for _,dingus in ipairs(dinguses) do
            if not ((dingus.x >= 0 and dingus.x <= 800) and (dingus.y >= 0 and dingus.y <= 800)) then goto continue end
            dingus:draw()
            ::continue::
        end

        love.graphics.setColor(0,0,0)
        for xx=0,3,1 do
            for yy=0,3,1 do
                love.graphics.printf("score: "..score.." | misses: "..misses,0+xx-1,373+yy-1,400,"center")
            end
        end
        love.graphics.setColor(1,1,1)
        love.graphics.printf("score: "..score.." | misses: "..misses,0,373,400,"center")

    love.graphics.setCanvas()

    -- stage

    camera:attach()
        state.stage:draw(camera.x,camera.y)

        chars.badguy:draw(state.stage.charpos.badguy[1],state.stage.charpos.badguy[2],0,2,2)
        Assets["spr_speaker"]:draw(state.stage.charpos.lady[1],state.stage.charpos.lady[2]-54,speakerind,0,2,2,Assets["spr_speaker"].width/2,Assets["spr_speaker"].height/2)
        chars.lady:draw(state.stage.charpos.lady[1],state.stage.charpos.lady[2],0,2,2)
        chars.player:draw(state.stage.charpos.player[1],state.stage.charpos.player[2],0,2,2)
    camera:detach()

    -- ui

    love.graphics.print("fps: "..love.timer.getFPS().." ("..round(1.0 / love.timer.getDelta())..")",10,10)
    love.graphics.print("conductor y: "..conductor.y,10,20)
    love.graphics.print("notes: "..#dinguses,10,30)
    love.graphics.print("campos: ("..camera.x..", "..camera.y..")",10,40)

    love.graphics.draw(notesurf,0,0,0,2,2)
    fade:draw()
end

return state