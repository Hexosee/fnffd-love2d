local paths = require "lib.paths"
local module = {}

function module.lerp(a,b,t)
	return a + (b - a) * module.d(t)
end

function module.clamp(val,min,max) -- i need my clam p../.
	return math.max(math.min(val,max),min)
end

function module.d(t)
	return math.min(t*love.timer.getDelta()*60,0.7) -- min fixes minimise bug (looking at you, robot 64.)
end

function module.split(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
  end

function module.keys(tab)
	local keyset = {}
	for k,v in pairs(tab) do
	  keyset[#keyset + 1] = k
	end
	return keyset
  end

function module.makeAnim(image, width, height, speed, duration)
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	animation.width = width
	animation.height = height

	animation.speed = speed
	animation.frame = 1


	for x = 0, image:getWidth(), width do
		table.insert(animation.quads, love.graphics.newQuad(x, 0, width, height, image:getDimensions()))
	end

	animation.duration = duration or 1

	function animation:bop()
		self.frame = 1
	end

	function animation:update()
		if self.frame < duration then
			self.frame=self.frame+module.d(self.speed)
		end
	end

	function animation:draw(x,y,r,sx,sy,ox,oy)
		if sx == nil then sx = 1 end
		if sy == nil then sy = 1 end
		if ox == nil then ox = 0 end
		if oy == nil then oy = 0 end

		local spriteNum = math.floor(self.frame)
		love.graphics.draw(self.spriteSheet, self.quads[spriteNum], x, y, r, sx,sy,ox,oy)
	end

	return animation
end

function module.makeAnimGM(image, width, height) -- idiot hexose
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	animation.width = width
	animation.height = height

	for x = 0, image:getWidth(), width do
		table.insert(animation.quads, love.graphics.newQuad(x, 0, width, height, image:getDimensions()))
	end


	function animation:draw(x,y,num,r,sx,sy,ox,oy)
		if sx == nil then sx = 1 end
		if sy == nil then sy = 1 end
		if ox == nil then ox = 0 end
		if oy == nil then oy = 0 end

		love.graphics.draw(self.spriteSheet, self.quads[num], x, y, r, sx,sy,ox,oy)
	end

	return animation
end

function module.newFade(type,speed,r,g,b)
	local fade = {}

	fade.r = r/255
	fade.b = b/255
	fade.g = g/255

	fade.type = type

	if fade.type == "in" then
		fade.alpha = 0
	else
		fade.alpha = 1
	end
	fade.speed = speed

	fade.onFinished = function() end

	function fade:setOnFinished(func)
		self.onFinished = func
	end

	function fade:update()
		if self.type == "in" and self.alpha < 1 then
			self.alpha=self.alpha+module.d(speed)
		elseif self.type == "out" and self.alpha > 0 then
			self.alpha=self.alpha-module.d(speed)
		end

		if self.type == "in" and self.alpha > 1 then
			fade.onFinished()
		elseif self.type == "out" and self.alpha < 0 then
			fade.onFinished()
		end
	end

	function fade:draw()
		love.graphics.setColor(self.b,self.b,self.b,self.alpha)
		love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(1,1,1,1)
	end

	return fade
end

function module.Character()
	local minimod = {}	
	function minimod:new(charname)
		local char = require(paths.char(charname))

		local character = {}

		character.name = charname
		character.curAnim = "idle"
		character.lastAnim = "idle"
		character.animations = char.animations
		character.sprites = {}
		character.resetTimer = 0 -- pick a case and STICK WITH IT!
		character.canReset = true

		for i,anim in ipairs(module.keys(character.animations)) do
			local curanim = character.animations[anim]
			local sheet = love.graphics.newImage(paths.image("characters/"..char.name.."/"..curanim.sprite))

			character.sprites[anim] = module.makeAnim(sheet,curanim.size[1],curanim.size[2],curanim.framerate,curanim.duration)
		end
		function character:update() -- this feels dumb
		
			self.resetTimer = self.resetTimer - module.d(1)
		
			for i,anim in ipairs(module.keys(self.sprites)) do
				self.sprites[anim]:update()
			end

			if self.lastAnim ~= self.curAnim then
				self.resetTimer = 60
			end

			if self.resetTimer < 0 and self.curAnim ~= "idle" and self.canReset then
				self.curAnim = "idle"
			end

			self.lastAnim = self.curAnim
		end

		function character:bop()
			for i,anim in ipairs(module.keys(self.sprites)) do
				self.sprites[anim]:bop()
			end
		end

		function character:draw(x,y,r,sx,sy)
			self.sprites[self.curAnim]:draw(x,y,r,sx,sy,self.animations[self.curAnim].offsets[1],self.animations[self.curAnim].offsets[2])
			--love.graphics.print(self.sprites[self.curAnim].frame,x,y,0,sx,sy)
		end

		function character:copy()
			return minimod:new(character.name)
		end

		return character
	end
	return minimod
end

return module