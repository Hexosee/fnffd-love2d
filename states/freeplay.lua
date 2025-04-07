local paths = require "lib.paths"
local coolshit = require "lib.coolshit"
local state = {}

local function split(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
  end

local names = {}
local swowses = {}
local icons = {}

local lerpy = 0
local col = 0
local sel = 1
local fade = coolshit.newFade("out",0.1,0,0,0)

function state.init()
    local lines = {}
    for line in love.filesystem.lines(paths.data("songs.txt")) do
        table.insert(lines,line)
    end
    for i,thing in ipairs(lines) do
        names[i] = split(thing,";")[1]
        swowses[i] = split(thing,";")[2]
        icons[i] = split(thing,";")[3]
    end
end

function state.update()
    lerpy = coolshit.lerp(lerpy,sel*-80,0.15)
    col = coolshit.lerp(col,sel,0.1)

    if fade ~= nil then
        fade:update()
    end

end

function state:keypressed(key)
    if key == "up" then
        sel=sel-1
    end
    if key == "down" then
        sel=sel+1
    end
    if key == "return" then 
        fade = coolshit.newFade("in",0.1,0,0,0)
        fade:setOnFinished(function()
            Gamestate.switch(States.stage,swowses[sel])
        end)
    end
    sel = coolshit.clamp(sel,1,#names)
end

function HSL(h, s, l, a) -- https://love2d.org/wiki/HSL_color
	if s<=0 then return l,l,l,a end
	h, s, l = h*6, s, l
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return r+m, g+m, b+m, a
end
function state.draw()
    -- i realise i'm not upscaling any of these menus
    -- oh well
    local goog = (((col/2)-0.5) / 5) % 1
    love.graphics.setColor(HSL(goog,0.5,0.5,1))
    Assets["spr_menubacksg"]:draw(0,lerpy/2,4,0,4,4)
    love.graphics.setColor(HSL(goog,0.5,0.5,0.25))
    love.graphics.rectangle("fill",0,0,800,800)
    for i,thing in ipairs(names) do
        love.graphics.setColor(0,0,0,1)
        for xx=0,6,1 do
            for yy=0,6,1 do
                love.graphics.print(thing,35+xx-2,400+(i*80)+lerpy+yy-2,0,2,2,0,Assets["fnt_comic1"]:getHeight()/4)
            end
        end

        if sel ~= i then
            love.graphics.setColor(0.5,0.5,0.5,1)
        else
            love.graphics.setColor(1,1,1,1)
        end
        love.graphics.print(thing,35,400+(i*80)+lerpy,0,2,2,0,Assets["fnt_comic1"]:getHeight()/4)
        Assets["spr_freeplayicons"]:draw(750,400+(i*400)+lerpy*5,tonumber(icons[i]),0,2,2,Assets["spr_freeplayicons"].width,Assets["spr_freeplayicons"].height/2)
        love.graphics.setColor(1,1,1,1)
    end

    if fade ~= nil then
        fade:draw()
    end
end

return state