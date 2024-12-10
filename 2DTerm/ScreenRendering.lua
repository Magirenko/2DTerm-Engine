local sf = require("SimpleFunctions")

local ScreenRendering = {
  ScreenContent = {
    complete = [[]],
    workspace = [[]],
    ui = [[]]
  },
  config = {
    fps = 60, -- Fps a renderizar, Recomandado ajustar para reducir el consumo de memoria en mucho movimiento
    fpsEstable = true,
    maxfps = 30
  }
}

local fps = ScreenRendering.config.fps
local oldclock = 0

function ScreenRendering:DelayUntilNextFrame()
  if oldclock ~= 0 then
    if os.clock() >= oldclock + (1 / fps) then
      oldclock = 0
      return true
    else
      return false
    end
  else
    oldclock = os.clock()
    ScreenRendering:DelayUntilNextFrame()
  end
end

function ScreenRendering:actualizar()
  io.write("\027[2J\027[0;0H".. ScreenRendering.ScreenContent.ui)
  io.flush()
end

return ScreenRendering