script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version("1")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

update_status = false

local script_vers = 4
local script_vers_text = "1.04"

local update_url = "https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/XakerTv/moontools/raw/refs/heads/main/tools.lua"
local script_path = thisScript().path

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

function main()
    while not isSampAvailable() do wait(0) end
    local playerId = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    local playerName = sampGetPlayerNickname(playerId)
    sampAddChatMessage(scriptName .. " ������ ����� � ������.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " � ������������, " .. playerName, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������� ������� ����: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������ �������: " .. scriptVersion, 0xBFBFBF)

    -- ����������� ������� /update
    sampRegisterChatCommand("update", function()
        checkForUpdate()
    end)

    while true do
        wait(0)
        if update_status then
            updateScript()
            break
        end
    end
end

-- ������� ��� �������� ����������
function checkForUpdate()
    sampAddChatMessage(scriptName .. ' �������� ����������...', 0xFFFFFF)
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local updateIni = inicfg.load(nil, update_path)
            if updateIni and updateIni.info then
                if tonumber(updateIni.info.vers) > script_vers then
                    sampAddChatMessage(scriptName .. ' �������� ����������! ������: ' .. updateIni.info.vers_text, -1)
                    update_status = true
                else
                    sampAddChatMessage(scriptName .. ' � ��� ��������� ������.', 0xFFFFFF)
                end
            else
                sampAddChatMessage(scriptName .. ' ������: update.ini ����������� ��� ����� ������������ ������.',
                    0xFF0000)
            end
        else
            sampAddChatMessage(scriptName .. ' ������ �������� update.ini.', 0xFF0000)
        end
    end)
end

-- ������� ��� ���������� �������
function updateScript()
    sampAddChatMessage(scriptName .. ' ���������� ��������. ����������, ���������...', 0xFFFFFF)
    downloadUrlToFile(script_url, script_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage(scriptName .. ' ������ ������� ��������!', -1)
            sampAddChatMessage(scriptName .. '==============���������� ' .. scriptVersion .. ' ==============', 0x8B59FF)
            sampAddChatMessage(scriptName .. '* ���������: *', -1)
            sampAddChatMessage(scriptName .. '- ������� ��������������', -1)
            thisScript():reload()
        elseif status == dlstatus.STATUS_ERROR then
            sampAddChatMessage(scriptName .. ' ������ �������� ������ �������.', 0xFF0000)
        end
    end)
end
