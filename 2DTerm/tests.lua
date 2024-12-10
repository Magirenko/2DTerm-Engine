local sf = require("SimpleFunctions")
local ui = require("LettUI")
local sr = require("ScreenRendering")
local portadainfo = {
  name = "portada",
  type = "screen",
  pos = {40, 6},
  size = {45, 10},
  state = "displaying",
  childs = {
    text = {
      name = "text",
      type = "label",
      aligment = "Middle",
      pos = {23, 3},
      state = "displaying",
      text = "Salvapantallas de un cubo tipo Texto? "
    },
    text2 = {
      name = "text2",
      type = "label",
      pos = {14, 5},
      state = "displaying",
      text = "Hecho por MagicM"
    },
    text3 = {
      name = "text3",
      type = "label",
      pos = {22, 6},
      state = "displaying",
      aligment = "Middle",
      text = "Usando 2DTerm Engine: v0.1"
    }
  }
}

local TestInfo = {
  name = "smh",
  type = "screen",
  pos = {2, 1},
  size = {1, 1},
  state = "displaying"
}
local Memory = {
  name = "MemoryCounter",
  type = "label",
  pos = {0, 0},
  state = "displaying",
  text = "Cargando..."
}
ui:new(portadainfo)
ui:new(TestInfo)
ui:new(Memory)
sf:wait(3)
ui:SetUIState(ui.Registered[1], "hidden")
sf:wait(1.3)
local inc = 1
local inc2 = 1
local ac = 4
for i = 1, 12350 do
  sf:wait(1 / ac)
  ui:Actualizar()
  ui.Registered[2].pos = { ui.Registered[2].pos[1] + inc2, ui.Registered[2].pos[2] + inc }
  if collectgarbage("count") <= 10000000 then
    ui.Registered[3].text = string.sub(tostring(collectgarbage("count")), 1, 3) .. "kb Uso de memoria"
  end
  if ui.Registered[2].pos[2] >= 25 or ui.Registered[2].pos[2] <= 0 then
    if inc == 1 then
      inc = -1
    elseif inc == -1 then
      inc = 1
    end
    ac = ac + 1
  end
  if ui.Registered[2].pos[1] >= 160 or ui.Registered[2].pos[1] <= 2 then
    if inc2 == 1 then
      inc2 = -1
    elseif inc2 == -1 then
      inc2 = 1
    end
    ac = ac + 1
  end
end