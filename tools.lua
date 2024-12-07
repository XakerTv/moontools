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

-- Функция для загрузки с повторными попытками
function downloadWithRetry(url, path, retries, delay)
    local attempt = 1

    local function tryDownload()
        if attempt > retries then
            sampAddChatMessage(scriptName .. "Ошибка загрузки после " .. retries .. " попыток.", 0xFF0000)
            return false
        end

        sampAddChatMessage(scriptName .. "Попытка загрузки " .. attempt .. "...", 0xFFFFFF)
        downloadUrlToFile(url, path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage(scriptName .. "Файл успешно загружен.", 0x00FF00)
                return true
            else
                sampAddChatMessage(scriptName .. "Ошибка загрузки. Статус: " .. tostring(status), 0xFF0000)
                attempt = attempt + 1
                lua_thread.create(function()
                    wait(delay)   -- Ожидание перед следующей попыткой
                    tryDownload() -- Рекурсивный вызов
                end)
            end
        end)
    end

    tryDownload() -- Начинаем первую попытку
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('update', cmd_update)

    local success, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if not success then
        sampAddChatMessage(scriptName .. 'Ошибка получения ID игрока.', 0xFF0000)
        return
    end
    local nick = sampGetPlayerNickname(id)
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

    -- Удаляем временный файл update.ini, если он существует
    if doesFileExist(update_path) then
        local success = os.remove(update_path)
        if not success then
            sampAddChatMessage(scriptName .. 'Ошибка удаления update.ini.', 0xFF0000)
            return
        end
    end

    -- Загружаем файл update.ini с ретрай логикой
    local success = downloadWithRetry(update_url, update_path, 3, 500)
    if not success then
        sampAddChatMessage(scriptName .. "Ошибка загрузки update.ini после нескольких попыток.", 0xFF0000)
        return
    end

    -- Загружаем ini-файл
    local updateIni = inicfg.load(nil, update_path)

    -- Проверяем, загружен ли ini-файл
    if not updateIni then
        sampAddChatMessage(scriptName .. 'Ошибка: не удалось загрузить update.ini.', 0xFF0000)
        os.remove(update_path)
        return
    end

    -- Добавление проверки на наличие секции [info] и полей vers/vers_text
    if not updateIni.info or not updateIni.info.vers or not updateIni.info.vers_text then
        sampAddChatMessage(scriptName .. 'Ошибка: update.ini повреждён или имеет неверный формат.', 0xFF0000)
        os.remove(update_path)
        return
    end

    -- Проверяем версию
    if tonumber(updateIni.info.vers) > script_vers then
        sampAddChatMessage(scriptName .. 'Найдено обновление! Версия: ' .. updateIni.info.vers_text, -1)

        -- Удаляем старый скрипт, если он существует
        if doesFileExist(script_path) then
            local success = os.remove(script_path)
            if not success then
                sampAddChatMessage(scriptName .. 'Ошибка удаления старого скрипта.', 0xFF0000)
                return
            end
        end

        -- Загружаем новый скрипт
        downloadUrlToFile(script_url, script_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage(scriptName .. 'Скрипт успешно обновлен!', -1)
                sampAddChatMessage(scriptName .. '========================ОБНОВЛЕНИЕ========================', -1)
                sampAddChatMessage(scriptName .. 'Добавлено:', -1)
                sampAddChatMessage(scriptName .. '- Автообновление скрипта', -1)
                thisScript():reload()
            else
                sampAddChatMessage(
                    scriptName .. 'Ошибка загрузки нового скрипта. Код статуса: ' .. tostring(status), 0xFF0000)
            end
        end)
    else
        sampAddChatMessage(scriptName .. 'Обновлений не найдено. Текущая версия: ' .. script_vers_text, 0xFFFFFF)
    end

    -- Удаляем временный файл update.ini
    os.remove(update_path)
end
