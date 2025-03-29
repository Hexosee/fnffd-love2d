local paths = {}

function paths.image(img)
    return "assets/images/"..img..".png"
end

function paths.audio(snd)
    return "assets/audio/"..snd..".ogg"
end

return paths