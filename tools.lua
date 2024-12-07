script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version('2')

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

require 'lib.moonloader'
local encoding = require 'encoding'
local requests = require 'requests'
local dlstatus = require('moonloader').download_status

encoding.default = 'CP1251'
u8 = encoding.UTF8

-- Подключаем dkjson для работы с JSON
local dkjson = require 'dkjson'

function decodeJson(data)
    return dkjson.decode(data)
end

function update()
    local raw = 'https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/updater.json'
    local f = {}

    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end

    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            local tempPath = getWorkingDirectory() .. '\\temp_script.lua'
            downloadUrlToFile(decodeJson(response.text)['url'], tempPath, function(id, status)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    os.rename(tempPath, thisScript().path) -- Заменяем текущий скрипт
                    sampAddChatMessage(scriptName .. ' Скрипт обновлен. Перезагрузка...', -1)
                    thisScript():reload()
                elseif status == dlstatus.STATUSEX_ERROR then
                    sampAddChatMessage(scriptName .. ' Ошибка скачивания обновления.', -1)
                end
            end)
        else
            sampAddChatMessage(scriptName .. ' Ошибка: невозможно установить обновление. Код: ' .. response.status_code,
                -1)
        end
    end

    return f
end

function main()
    while not isSampAvailable() do wait(0) end

    -- Автообновление
    local updater = update()
    local lastVersion = updater:getLastVersion()
    if lastVersion ~= scriptVersion then
        sampAddChatMessage(scriptName .. " Доступна новая версия скрипта: " .. lastVersion, 0xFFFF00)
        updater:download()
        return
    end

    -- Основная функциональность
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    sampAddChatMessage(scriptName .. " Скрипт готов к работе.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " С возвращением, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " Открыть главное меню: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " Версия скрипта: " .. scriptVersion, 0xBFBFBF)

    while true do
        wait(0)
    end
end
