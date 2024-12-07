script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version("1")

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = '2.00'

local update_url = 'https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/update.ini'
local update_path = getWorkingDirectory() .. '/update.ini'

local script_url = 'https://github.com/XakerTv/moontools/raw/refs/heads/main/tools.lua'
local script_path = thisScript().path

function main()
    while not isSampAvailable() do wait(0) end

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    sampAddChatMessage(scriptName .. " Скрипт готов к работе.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " С возвращением, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " Открыть главное меню: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " Версия скрипта: " .. scriptVersion, 0xBFBFBF)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(scriptName .. 'Есть обновление скрипта! Устанавливаем...', 0xff0000)
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage('Обновление скачано!', 0xff0000)
                    sampAddChatMessage(scriptName .. '==============ОБНОВЛЕНИЕ' .. scriptVersion .. '==============',
                        0x8B59FF)
                    sampAddChatMessage(scriptName .. '* Добавлено: *', -1)
                    sampAddChatMessage(scriptName .. '- Функция автообновления', -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end
