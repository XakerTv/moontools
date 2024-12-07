script_name('MoonTools')
script_author('Tech')
script_description('AutoUpdate')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1
local script_vers_text = '1.0'

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

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(scriptName .. 'Найдено обновление! Версия: ' .. updateIni.info.vers_text, -1)
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
                    sampAddChatMessage(scriptName .. 'Скрипт успешно обновлён!', -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end
