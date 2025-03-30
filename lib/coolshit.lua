local module = {}

function module.lerp(a,b,t)
	return a + (b - a) * t
end

function module.makeAnim(image, width, height, speed, duration)
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	animation.width = width
	animation.height = height

	animation.speed = speed
	animation.frame = 1

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	animation.duration = duration or 1

	function animation:bop()
		self.frame = 1
	end

	function animation:update()
		if self.frame < duration then
			self.frame=self.frame+self.speed
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
		if self.type == "in" and self.alpha >= 1 then
			self.alpha=self.alpha+speed
		elseif self.type == "out" and self.alpha <= 1 then
			self.alpha=self.alpha-speed
		end
	end

	function fade:draw()
		love.graphics.setColor(self.b,self.b,self.b,self.alpha)
		love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(1,1,1,1)
	end

	return fade
end


return module