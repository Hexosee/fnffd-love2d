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

return paths