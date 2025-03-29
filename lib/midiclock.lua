local midi = {}

-- david stearns if he was Love two dee?

midi.song = nil
midi.time = 0
midi.bpm = 110
midi.paused = false

midi.measure = 1
midi.quarter_count = 0

midi.div_4 = 0
midi.div_8 = 0
midi.div_16 = 0
midi.div_32 = 0

midi.div_4_previous = midi.div_4
midi.div_8_previous = midi.div_8
midi.div_16_previous = midi.div_16
midi.div_32_previous = midi.div_32

midi.div_4_trigger = false
midi.div_8_trigger = false
midi.div_16_trigger = false
midi.div_32_trigger = false

function midi.update()
    if midi.song ~= nil and not midi.paused then
        midi.time = midi.song:tell("seconds")*1000000

        midi.div_4_previous = midi.div_4
        midi.div_8_previous = midi.div_8
        midi.div_16_previous = midi.div_16
        midi.div_32_previous = midi.div_32

        midi.div_4 = (math.floor(midi.time/(60000000/midi.bpm)) % 4) + 1
        midi.div_8 = (math.floor(midi.time/(60000000/2/midi.bpm)) % 4) + 1
        midi.div_16 = (math.floor(midi.time/(60000000/4/midi.bpm)) % 4) + 1
        midi.div_32 = (math.floor(midi.time/(60000000/8/midi.bpm)) % 4) + 1

        if midi.div_4_previous ~= midi.div_4 then
            midi.quarter_count=midi.quarter_count+1
            midi.div_4_trigger = true
        else
            midi.div_4_trigger = false
        end

       midi.div_8_trigger = midi.div_8_previous ~= midi.div_8
       midi.div_16_trigger = midi.div_16_previous ~= midi.div_16
       midi.div_32_trigger = midi.div_32_previous ~= midi.div_32
    else
        midi.div_4_trigger = false
        midi.div_8_trigger = false
        midi.div_16_trigger = false
        midi.div_32_trigger = false
    end
end

return midi