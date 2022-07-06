local conductor = {}

conductor.bpm = 100
conductor.crochet = ((60 / conductor.bpm) * 1000)
conductor.stepCrochet = conductor.crochet / 4
conductor.songPosition = 0
conductor.songPositionInBeats = 0
conductor.songPositionInSteps = 0
conductor.fakeCrochet = (60 / conductor.bpm) * 1000
conductor.totalLength = 0
local source = nil

function conductor.init(n)
    source = n
end

function conductor.calculateCrochet(bpm)
    return ((60 / bpm) * 1000)
end

function conductor.calculateStepCrochet(bpm)
    return ((60 / bpm) * 1000) / 4
end

function conductor.setBeat(beat)
    source:seek(beat * 60 / conductor.bpm)
end

function conductor.setSpeed(n)
    source:setPitch(n)
end

function conductor.changeBPM(newBpm)
    conductor.bpm = newBpm
    conductor.crochet = conductor.calculateCrochet(conductor.bpm)
    conductor.stepCrochet = conductor.crochet / 4
end

return conductor
