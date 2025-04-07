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
    object.type = 1

    object.candraw = {
        [1]=true,
        [2]=true,
        [3]=true,
        [4]=false,
        [5]=false,
        [6]=false,
        [7]=false,
        [8]=true,
        [9]=true,
        [10]=false
    }

    function object:update(x,y,sucker)
        local starty
        if Settings.downscroll then
            starty = 352
        else
            starty = 48
        end
        self.y = self.yy+(y-starty)
        self.x=self.xx+x -- ???

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

    function object:draw()
        if self.candraw[self.type] then
            -- this took shamefully long and i'm not happy
            -- fuck you makeAnimGM ..
            if self.type == 8 or self.type == 9 then
                love.graphics.setColor(1,1,1,0.5) -- temporary
            end
            if self.note <= 3 then
                Assets["spr_notes"]:draw(self.x,self.y,self.note+1,0,1,1,Assets["spr_notes"].width/2,Assets["spr_notes"].height/2)
            else
                Assets["spr_notes"]:draw(self.x,self.y,self.note-3,0,1,1,Assets["spr_notes"].width/2,Assets["spr_notes"].height/2)
            end
            --love.graphics.print(self.y,self.x,self.y)
            love.graphics.setColor(1,1,1,1)
        end
    end

    return object

end

return module