function startGame(song)
    Timer.clear()
    GameVars.song.name = song
    GameVars.song.bpm = love.filesystem.read('assets/songs/' .. song .. '/bpm')
    GameVars.second = love.filesystem.read('assets/songs/' .. song .. '/second')
    State.switch(States.game)
end