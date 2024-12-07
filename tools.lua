script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version("1")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require('moonloader').download_status

update_state = false -- Если переменная == true, значит начнётся обновление.
update_found = false -- Если будет true, будет доступна команда /update.

local script_vers = 1
local script_vers_text =
"1.0" -- Название нашей версии. В будущем будем её выводить ползователю.

local update_url =
'https://www.dropbox.com/scl/fi/1mifj2d4jorajt7h8x00z/update.ini?rlkey=i9gtvifpq77ovdviyykofkyoa&st=6h1bmzqo&dl=0' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url =
'https://www.dropbox.com/scl/fi/v9viclmaf7utsu1hqwlew/tools.lua?rlkey=y7nur7pnzh1t7imu7ptnmnb1u&st=v9m88tj0&dl=0' -- Путь скрипту.
local script_path = thisScript().path

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

function check_update() -- Создаём функцию которая будет проверять наличие обновлений при запуске скрипта.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Сверяем версию в скрипте и в ini файле на github
                sampAddChatMessage(
                    scriptName ..
                    "{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}" ..
                    updateIni.info.vers_text .. ". {FFFFFF}/update что-бы обновить", 0xFF0000) -- Сообщаем о новой версии.
                update_found = true -- если обновление найдено, ставим переменной значение true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update()

    if update_found then                             -- Если найдено обновление, регистрируем команду /update.
        sampRegisterChatCommand('update', function() -- Если пользователь напишет команду, начнётся обновление.
            update_state = true                      -- Если человек пропишет /update, скрипт обновится.
        end)
    else
        sampAddChatMessage('{FFFFFF}Нету доступных обновлений!')
    end

    while true do
        wait(0)

        if update_state then -- Если человек напишет /update и обновление есть, начнётся скачивание скрипта.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(scriptName .. "{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                end
            end)
            break
        end
    end
end
