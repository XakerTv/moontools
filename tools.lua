script_name("LunaTools")    -- РѕС‚Р»Р°РґРєР°
script_author("HermitTech") -- Р°РІС‚РѕСЂ
script_description("Luna Tools. Vers. 1")
script_version("1")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

update_status = false

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = ""
local script_path = thisScript().path

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"

function main()
    while not isSampAvailable() do wait(0) end
    local playerId = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    local playerName = sampGetPlayerNickname(playerId)
    sampAddChatMessage(scriptName .. " Скрипт готов к работе.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " С возвращением, " .. playerName, 0xFFFFFF)
    --sampAddChatMessage(scriptName .. " Открыть главное меню: /mtools", 0xFFFFFF)
    --sampAddChatMessage(betaScriptName .. " Версия скрипта: " .. scriptVersion, 0xBFBFBF)
    --sampRegisterChatCommand('mtools', function()
    --    renderWindow[0] = not renderWindow[0]
    --end)
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(scriptName .. ' Доступно обновление! Версия: ' .. updateIni.info.vers_text, -1)
                update_status = true
            end
            os.remove(update_path)
        end
    end)

    while true do
        wait(0)

        if update_status then
            downloadUrlToFile(update_url, update_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(scriptName .. 'Скрипт успешно обновлен!', -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end
