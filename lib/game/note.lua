local module = {}
-- i should really move this to use hump's classes instead of whatever the fuck i'm doing
-- i'm learning!

function module:create(x,y,note)

    local object = {}

    object.x = x
    object.y = y

    object.xx = x
    object.yy = y

    object.note = note

    function object:update(x,y)
        local starty
        if Settings.downscroll then
            starty = 352
        else
            starty = 48
        end
        self.y = self.yy+(y-starty)
        self.x=self.xx+x -- ???
        print(self.y)
    end
    
    function object:draw()
        -- this took shamefully long and i'm not happy
        -- fuck you makeAnimGM ..
        if self.note <= 3 then
            Assets["spr_notes"]:draw(self.x,self.y,self.note+1,0,1,1,Assets["spr_notes"].width/2,Assets["spr_notes"].height/2)
        else
            Assets["spr_notes"]:draw(self.x,self.y,self.note-3,0,1,1,Assets["spr_notes"].width/2,Assets["spr_notes"].height/2)
        end
        --love.graphics.print(self.y,self.x,self.y)
    end

    return object

end

return module