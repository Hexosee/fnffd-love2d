local paths = {}

function paths.image(img)
    return "assets/images/"..img..".png"
end

function paths.audio(snd)
    return "assets/audio/"..snd..".ogg"
end

function paths.font(fnt)
    return "assets/fonts/"..fnt..".ttf"
end

function paths.swows(swow)
    return "assets/data/charts/"..swow..".swows"
end

function paths.data(whatever)
    return "assets/data/"..whatever
end

function paths.char(char)
    return "assets/data/characters/"..char
end

function paths.stage(char)
    return "assets/data/stages/"..char
end

return paths