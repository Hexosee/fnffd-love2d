local module = {}
-- i should really move this to use hump's classes instead of whatever the fuck i'm doing
-- i'm learning!

function module:create(x,y,note)

    local object = {}

    object.x = x
    object.y = y
    object.note = note

    function object:update()
        if self.note > 4 then
            if love.keyboard.isDown( Settings.binds[1]) then
                self.pressed = true
            else
                self.pressed = false
            end
        end
    end
    
    function object:draw()
        -- this took shamefully long and i'm not happy
        -- fuck you makeAnimGM ..
        if self.note <= 3 then
            Assets["spr_uinotes"]:draw(self.x,self.y,self.note+1,0,1,1,Assets["spr_uinotes"].width/2,Assets["spr_uinotes"].height/2)
        else
            Assets["spr_uinotes"]:draw(self.x,self.y,self.note-3,0,1,1,Assets["spr_uinotes"].width/2,Assets["spr_uinotes"].height/2)
        end
    end

    return object

end

return module