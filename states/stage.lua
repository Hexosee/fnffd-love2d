-- every swows implementation i make is scuffed in some way :broken_heart:

local state = {}

local conduct = require("lib.game.conductor")
local paths = require("lib.paths")

local uinote = require("lib.game.uinote")
local note = require("lib.game.note")

local conductor = conduct.Conductor()

local suckers = {}
local dinguses = {}

local ready = false

local notesurf = love.graphics.newCanvas(400,400)

local dosc,starty,syncfix

local round = function(n)
	return math.floor(n + 0.5)
end

function state:enter(prev,rawsong)
    local song = Assets[rawsong]
    local path = paths.swows(rawsong)

    local lines = {}
    for line in love.filesystem.lines(path) do
        table.insert(lines,line)
    end

    table.remove(lines,1) -- sorry songname fans
    local bpm = lines[1]
    table.remove(lines,1)
    local notespeed = lines[1]
    table.remove(lines,1)
    table.remove(lines,1) -- skip keys variable (I AM NEVER ADDING MULTI KEY SUPPORT)

    -- var songlong=round(((audio_sound_length(obj_song.song)/60)*obj_song.bpm*4));
    -- 1361
    -- 145.82142639160156
    -- 72.78947845805
    local songlong = round( (song:getDuration("seconds")/60) * bpm * 4)
    print("\nmy name songlong")
    print(songlong)
    print(song:getDuration("seconds"))
    if Settings.downscroll then
        dosc = -1
        starty = 352
        syncfix = 0 -- porting EXPERT
    else
        dosc = 1
        starty = 48
        syncfix = 48*2
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

        for b=0, songlong, 1 do
            if tonumber(lines[1]) ~= 0 then
                local dingus = note:create(myx,starty+(b*48*notespeed*dosc)+syncfix+(bb*48)*dosc,bb)
                table.insert(dinguses,dingus)

            end
            table.remove(lines,1)
        end
    end

    love.audio.stop()
    song:play()
    ready = true
end


function state:update()
    if not ready then return end
    conductor:update()
    for _,sucker in ipairs(suckers) do
        sucker:update()
    end
    for _,dingus in ipairs(dinguses) do
        dingus:update(conductor.x,conductor.y*-dosc)
    end
    
end

function state:draw()
    if not ready then return end
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,800,800)
    love.graphics.setColor(255,255,255)

    love.graphics.print("fps: "..love.timer:getFPS(),10,10)
    love.graphics.print("conductor y: "..conductor.y,10,20)

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
    love.graphics.setCanvas()

    love.graphics.draw(notesurf,0,0,0,2,2)
end

return state