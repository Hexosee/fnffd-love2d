local module = {}
-- i should really move this to use hump's classes instead of whatever the fuck i'm doing
-- i'm learning!

function module:create(x,y,note)

    local object = {}

    object.x = x
    object.y = y
    object.note = note
    object.pressed = false
    object._lastpressed = false
    object.hit = false

    function object:update()
        if not (self.note <= 3) then
            if love.keyboard.isDown(Settings.binds[self.note-3]) then
                self.pressed = true
            else
                self.pressed = false
            end

            if self._lastpressed ~= self.pressed and self.pressed == true then
                self.hit = true
            else
                self.hit = false
            end

            self._lastpressed = self.pressed
        end
    end
    
    function object:draw()
        -- this took shamefully long and i'm not happy
        -- fuck you makeAnimGM ..

        if self.note <= 3 then

            Assets["spr_uinotes"]:draw(self.x,self.y,self.note+1,0,1,1,Assets["spr_uinotes"].width/2,Assets["spr_uinotes"].height/2)
        else
            if self.pressed then 
                love.graphics.setColor(100,1,1,0.7)
            else
                love.graphics.setColor(1,1,1,1)
            end
            Assets["spr_uinotes"]:draw(self.x,self.y,self.note-3,0,1,1,Assets["spr_uinotes"].width/2,Assets["spr_uinotes"].height/2)
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(tostring(self.hit),self.x,self.y)
    end

    return object

end

return module