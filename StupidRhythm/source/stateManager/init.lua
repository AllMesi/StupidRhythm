local flux = Flux
local stateManager = {
    _tweenGroup = flux.group(),
    _backgroundColour = {0, 0, 0},
    _currentState = {
        draw = function()
            love.graphics.print("No state loaded", 0, 0)
        end
    },
    _subStates = {{
        tag = "nothing",
        state = {}
    }},
    _addedStates = {{
        tag = "nothing",
        state = {}
    }, {
        tag = "quit",
        state = {
            enter = function()
                love.event.quit()
            end
        }
    }},
    _transitionThing = {
        alpha = 0,
        switching = false
    },
    addState = function(self, state, tag)
        if not tag then
            error("stateManager:addState(state, tag) - tag is required")
        end
        for i, v in ipairs(self._addedStates) do
            if v.tag == tag then
                error("stateManager:addState(state, tag) - tag already exists")
            end
        end
        table.insert(self._addedStates, {
            tag = tag,
            state = state
        })
    end,
    switch = function(self, tag, transition)
        if tag ~= nil then
            for i, v in ipairs(self._addedStates) do
                if v.tag == tag then
                    if transition == true then
                        if not self._transitionThing.switching then
                            self._transitionThing.switching = true
                            self._transitionThing.alpha = 0
                            flux.to(self._transitionThing, 0.3, {
                                alpha = 255
                            }):ease("quartinout"):oncomplete(function()
                                if self._currentState ~= nil then
                                    if self._currentState.exit ~= nil then
                                        self._currentState.exit()
                                    end
                                end
                                self._subStates = {}
                                self._currentState = v.state
                                if self._currentState.preenter ~= nil then
                                    self._currentState.preenter()
                                end
                                flux.to(self._transitionThing, 0.3, {
                                    alpha = 0
                                }):ease("quartinout"):oncomplete(function()
                                    self._transitionThing.switching = false
                                    self._transitionThing.alpha = 0
                                    if self._currentState.enter ~= nil then
                                        self._currentState.enter()
                                    end
                                    collectgarbage()
                                end)
                            end)
                        end
                    else
                        if self._currentState ~= nil then
                            if self._currentState.exit ~= nil then
                                self._currentState.exit()
                            end
                        end
                        self._subStates = {}
                        self._currentState = v.state
                        if self._currentState.enter ~= nil then
                            self._currentState.enter()
                        end
                        collectgarbage()
                    end
                end
            end
        else
            print("An error occurred, either the state was nil or the state did not have a return at the end.")
        end
    end,
    addSubState = function(self, tag, state)
        table.insert(self._subStates, {
            tag = tag,
            state = state
        })
    end,
    getSubState = function(self, tag)
        for i, v in ipairs(self._subStates) do
            if v.tag == tag then
                return v.state
            end
        end
    end,
    removeSubState = function(self, tag)
        for i, v in ipairs(self._subStates) do
            if v.tag == tag then
                if v.state.exit ~= nil then
                    v.state.exit()
                end
                table.remove(self._subStates, i)
            end
        end
    end,
    draw = function(self)
        if self._currentState ~= nil then
            if self._currentState.draw ~= nil then
                love.graphics.clear(0, 0, 0)
                love.graphics.setColor(unpack(self._backgroundColour))
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
                love.graphics.setColor(255, 255, 255)
                self._currentState.draw()
            end
        end
        for i, v in ipairs(self._subStates) do
            if v.state.draw ~= nil then
                v.state.draw()
            end
        end
        if self._transitionThing.switching then
            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(0, 0, 0, self._transitionThing.alpha)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(r, g, b, a)
        end
    end,
    current = function(self)
        if self._currentState ~= nil then
            return self._currentState
        end
    end,
    update = function(self, dt)
        if not self._transitionThing.switching then
            if self._currentState ~= nil then
                if self._currentState.update ~= nil then
                    self._currentState.update(dt)
                end
            end
            for i, v in ipairs(self._subStates) do
                if v.state.update ~= nil then
                    v.state.update(dt)
                end
            end
        end
    end,
    keypressed = function(self, key)
        if not self._transitionThing.switching then
            if self._currentState ~= nil then
                if self._currentState.keypressed ~= nil then
                    self._currentState.keypressed(key)
                end
            end
            for i, v in ipairs(self._subStates) do
                if v.state.keypressed ~= nil then
                    v.state.keypressed(key)
                end
            end
        end
    end,
    keyreleased = function(self, key)
        if not self._transitionThing.switching then
            if self._currentState ~= nil then
                if self._currentState.keyreleased ~= nil then
                    self._currentState.keyreleased(key)
                end
            end
            for i, v in ipairs(self._subStates) do
                if v.state.keyreleased ~= nil then
                    v.state.keyreleased(key)
                end
            end
        end
    end,
    wheelmoved = function(self, x, y)
        if not self._transitionThing.switching then
            if self._currentState ~= nil then
                if self._currentState.wheelmoved ~= nil then
                    self._currentState.wheelmoved(x, y)
                end
            end
            for i, v in ipairs(self._subStates) do
                if v.state.wheelmoved ~= nil then
                    v.state.wheelmoved(x, y)
                end
            end
        end
    end,
    resize = function(self, w, h)
        if not self._transitionThing.switching then
            if self._currentState ~= nil then
                if self._currentState.resize ~= nil then
                    self._currentState.resize(w, h)
                end
            end
            for i, v in ipairs(self._subStates) do
                if v.state.resize ~= nil then
                    v.state.resize(w, h)
                end
            end
        end
    end,
    setBackgroundColour = function(self, colour, time)
        self._tweenGroup:to(self._backgroundColour, time, {colour[1], colour[2], colour[3]})
    end
}
return stateManager
