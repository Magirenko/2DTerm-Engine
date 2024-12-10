--[[
ooooo                      .       .   ooooo     ooo  o8o  
`888'                    .o8     .o8   `888'     `8'  `"'  
 888          .ooooo.  .o888oo .o888oo  888       8  oooo  
 888         d88' `88b   888     888    888       8  `888  
 888         888ooo888   888     888    888       8   888  
 888       o 888    .o   888 .   888 .  `88.    .8'   888  
o888ooooood8 `Y8bod8P'   "888"   "888"    `YbodP'    o888o
                   El modulo LettUI

   Copyright (C) 2024 MagicM, todos los derechos reservados.
]]

-- Modulos

local SimpleFuncs = require("SimpleFunctions")
local SR = require("ScreenRendering")

-- Variables

local LettUI = {
  Registered = {},
  Config = {
    UITheme = "white", -- Nota: Si el tema de tu terminal es blanco y pones blanco no se vera las pantallas.
    --[[
    Lista de Temas disponibles:
      - white: pantalla blanca y lo demas negro
      - black: pantalla negra y lo demas blanco
      - yellow: pantalla amarilla y lo demas negro
      - blue: pantalla azul y lo demas negro
      - gray: pantalla gris y lo demas blanco
      - green: pantalla verde y lo demas negro
      - red: pantalla roja y lo demas negro
    ]]--
    Style = "8bit" -- 8bit es el unico disponible, LettUI esta en desarrollo.
  }
}

local DefaultPos = {0, 0}
local DefaultEase = "Linear"
local DefaultSize = {3, 3}
local DefaultShape
local DefaultColor = ""
local DefaultUntitledUI = "Untitled UI"
local DefaultType = "screen"
local actualizado = false

-- Configurar variables

if LettUI.Config.UITheme == "white" then
  DefaultColor = "\027[47m"
elseif LettUI.Config.UITheme == "black" then
  DefaultColor = ""
elseif LettUI.Config.UITheme == "red" then
  DefaultColor = "\027[41m"
end
if LettUI.Config.Style == "8bit" then
  DefaultShape = ""
end

-- Funciones

function LettUI:CheckUI(UI, type)
  if UI then
    if type == "screen" then
      if UI.name ~= nil and UI.pos ~= nil and UI.size ~= nil and UI.state ~= nil then
        return true
      else
        return false
      end
    elseif type == "label" then
      if UI.name ~= nil and UI.pos ~= nil and UI.state ~= nil and UI.text ~= nil then
        return true
      else
        return false
      end
    end
  else
    return false
  end
end

function LettUI:Actualizar()
  if LettUI.Registered[1] then
    SR.ScreenContent.ui = [[]]
    for i, UI in pairs(LettUI.Registered) do
      if UI.state == "displaying" then
          if UI.type == "screen" then
            for i = 1, UI.size[2] do
              SR.ScreenContent.ui = SimpleFuncs:WriteFrom(SR.ScreenContent.ui, UI.pos[1] + UI.size[1], (UI.pos[2] + i), ("\b \b"):rep(UI.size[1]) .. (DefaultColor .. " ".. "\027[0m"):rep(UI.size[1]))
            end
          elseif UI.type == "label" then
            local AligmentEcuation
            if UI.aligment then
              if UI.aligment == "Left" then
                AligmentEcuation = UI.pos[1] + #UI.text
              elseif UI.aligment == "Right" then
                AligmentEcuation = #UI.text + UI.pos[1]
              elseif UI.aligment == "Middle" then
                AligmentEcuation = UI.pos[1]
              end
            else
              AligmentEcuation = UI.pos[1] + #UI.text
            end
            SR.ScreenContent.ui = SimpleFuncs:WriteFrom(SR.ScreenContent.ui, AligmentEcuation, UI.pos[2], ("\b \b"):rep(#UI.text) .. UI.text)
          end
        if UI.childs then
          if UI.type == "screen" then
            for i, child in pairs(UI.childs) do
              if LettUI:CheckUI(child, child.type) then
                if child.type == "label" then
                  if child.state == "displaying" then
                    local AligmentEcuation
            if child.aligment then
              if child.aligment == "Left" then
                AligmentEcuation = child.pos[1] + #child.text
              elseif child.aligment == "Right" then
                AligmentEcuation = math.floor(child.pos[1] + (#child.text / 3)) + 1
              elseif child.aligment == "Middle" then
                AligmentEcuation = math.floor(child.pos[1] + (#child.text / 2))
              end
            else
              AligmentEcuation = child.pos[1] + #child.text
            end
                    SR.ScreenContent.ui = SimpleFuncs:WriteFrom(SR.ScreenContent.ui, UI.pos[1] + AligmentEcuation, UI.pos[2] + 1 + child.pos[2], ("\b \b"):rep(#child.text) .. child.text)
                  end
                end
              end
            end
          else
            error("Error al actualizar las UIS: la UI no puede tener objetos siendo ".. UI.type)
          end
        end
      else
        if UI.type == "screen" then
          for i = 1, UI.size[2] do
            SR.ScreenContent.ui = SimpleFuncs:WriteFrom(SR.ScreenContent.ui, UI.pos[1] + UI.size[1], (UI.pos[2] + i), ("\b \b"):rep(UI.size[1]))
          end
        elseif UI.type == "label" then
          SR.ScreenContent.ui = SimpleFuncs:WriteFrom(SR.ScreenContent.ui, UI.pos[1] + #UI.text, UI.pos[2], ("\b \b"):rep(#UI.text))
        end
      end
    end
    SR:actualizar()
  else
    error("Error al actualizar las UIS: No hay ninguna UI registrada.")
  end
end

function LettUI:new(UITable)
  table.insert(LettUI.Registered, UITable)
  LettUI:Actualizar()
end

function LettUI:SetUIState(UI, state)
  if UI then
    if LettUI:CheckUI(UI, UI.type) then
      if (state == "hidden" or "displaying") then
        UI.state = state
        LettUI:Actualizar(UI)
      else
        error("Error al poner estado de UI: Estado invalido, pon 'hidden' o 'displaying'.")
      end
    else
      error("Error al poner estado de UI: el UI puesto no es valido.")
    end
  else
    error("Error al poner estado de UI: No pusiste un UI.")
  end
end

return LettUI