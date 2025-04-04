-- tyler mon if he was Love two dee?

local module = {}

function module.Conductor()
    local object = {}

    object.y = 0
    object.x = 0

    object.source = nil
    object.notespeed = 1
    object.bpm = 110

    object.songpos = 0
    if Settings.downscroll then
        object.dosc = -1
        object.starty = 352
    else
        object.dosc = 1
        object.starty = 48
    end

    function object:update()
        self.songpos = self.source:tell("seconds")
        local songlong = self.source:getDuration("seconds")
        local songper = self.songpos/songlong
        local songbeat = ((songlong/60*self.bpm*4)*(48*self.notespeed))*self.dosc
        self.y = self.starty+(songper*songbeat)*self.dosc
    end

    return object
end

return module