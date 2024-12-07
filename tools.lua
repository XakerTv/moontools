script_name('MoonTools')
script_author('Tech')
script_description('AutoUpdate')
script_version('1')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'encoding'
local encoding = require "encoding"

encoding.default = 'CP1251'
u8 = encoding.UTF8 -- ����� main ������ �������

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
    sampAddChatMessage(scriptName .. " ������ ����� � ������.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " � ������������, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������� ������� ����: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������ �������: " .. scriptVersion, 0xBFBFBF)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(scriptName .. '������� ����������! ������: ' .. updateIni.info.vers_text, -1)
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
                    sampAddChatMessage(scriptName .. '������ ������� ��������!', -1)
                    sampAddChatMessage(scriptName .. '==============����������' .. scriptVersion .. '==============',
                        0x8B59FF)
                    sampAddChatMessage(scriptName .. '* ���������: *', -1)
                    sampAddChatMessage(scriptName .. '- ������� ��������������', -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end
