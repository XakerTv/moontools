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

    sampAddChatMessage(scriptName .. " ������ ����� � ������.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " � ������������, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������� ������� ����: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������ �������: " .. scriptVersion, 0xBFBFBF)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            if doesFileExist(update_path) then
                updateIni = inicfg.load(nil, update_path)
                if updateIni and tonumber(updateIni.info.vers) > script_vers then
                    sampAddChatMessage(scriptName .. ' ���� ���������� �������! �������������...', 0xff0000)
                    update_state = true
                else
                    sampAddChatMessage(scriptName .. ' ������: ������������ ���� ����������.', 0xff0000)
                end
                os.remove(update_path)
            else
                sampAddChatMessage(scriptName .. ' ������: ���� ���������� �� ������.', 0xff0000)
            end
        else
            sampAddChatMessage(scriptName .. ' ������: �� ������� ������� ���� ����������.', 0xff0000)
        end
    end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage('���������� �������!', 0xff0000)
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
