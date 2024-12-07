script_name('MoonTools')
script_author('Tech')
script_description('AutoUpdate')
script_version('1')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require "encoding"

encoding.default = 'CP1251'
u8 = encoding.UTF8 -- перед main можешь пихнуть

update_state = false

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

local script_vers = 2
local script_vers_text = '2.0'

local update_url = "https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/update.ini" -- ini
local update_path = getWorkingDirectory() .. '/update.ini'

local script_url = "https://github.com/XakerTv/moontools/raw/refs/heads/main/tools.lua" -- lua
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('update', cmd_update)

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

function cmd_update()
    sampAddChatMessage(scriptName .. 'Проверка обновлений...', 0xFFFFFF)

    -- Удаляем временный файл, если он остался от предыдущей загрузки
    if doesFileExist(update_path) then
        os.remove(update_path)
    end

    -- Загрузка файла update.ini
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(scriptName .. 'Найдено обновление! Версия: ' .. updateIni.info.vers_text, -1)
                update_state = true

                -- Проверяем, занят ли файл скрипта
                if doesFileExist(script_path) then
                    os.remove(script_path) -- Удаляем старый скрипт
                end

                -- Загрузка нового скрипта
                downloadUrlToFile(script_url, script_path, function(id, status)
                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        sampAddChatMessage(scriptName .. 'Скрипт успешно обновлен!', -1)
                        sampAddChatMessage(scriptName .. '==============ОБНОВЛЕНИЕ' .. scriptVersion .. '==============',
                            0x8B59FF)
                        sampAddChatMessage(scriptName .. '* Добавлено: *', -1)
                        sampAddChatMessage(scriptName .. '- Функция автообновления', -1)
                        thisScript():reload()
                    else
                        sampAddChatMessage(scriptName .. 'Ошибка загрузки нового скрипта.', 0xFF0000)
                    end
                end)
            else
                sampAddChatMessage(scriptName .. 'Обновлений не найдено. Текущая версия: ' .. script_vers_text, 0xFFFFFF)
            end

            os.remove(update_path) -- Удаляем временный файл
        else
            sampAddChatMessage(scriptName .. 'Ошибка проверки обновлений.', 0xFF0000)
        end
    end)
end
