--[[
                               SimpleFunctions

                  SimpleFunctions, el Modulo de funciones
                  que lua necesita!
]]

local SimpleFuncs = {}

function SimpleFuncs:wait(tiempo) -- wait: espera una cantidad de tiempo para seguir con el codigo!
  local TiempoActual = os.clock()
  repeat until os.clock() >= TiempoActual + tiempo
  return os.clock()
end

function SimpleFuncs:WriteFrom(String, column, line, WriteText)
  return (String .. ("\027[".. line .. ";".. column .. "H") .. WriteText)
end

return SimpleFuncs