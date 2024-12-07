script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version("1")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require('moonloader').download_status

update_state = false -- ���� ���������� == true, ������ ������� ����������.
update_found = false -- ���� ����� true, ����� �������� ������� /update.

local script_vers = 2
local script_vers_text =
"2.0"                          -- �������� ����� ������. � ������� ����� � �������� �����������.

local update_url =
'https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/update.ini' -- ���� � ini �����. ����� ��� ������������.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://github.com/XakerTv/moontools/raw/refs/heads/main/tools.lua' -- ���� �������.
local script_path = thisScript().path

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

function check_update() -- ������ ������� ������� ����� ��������� ������� ���������� ��� ������� �������.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- ������� ������ � ������� � � ini ����� �� github
                sampAddChatMessage(
                    scriptName ..
                    "{FFFFFF}������� {32CD32}����� {FFFFFF}������ �������. ������: {32CD32}" ..
                    updateIni.info.vers_text .. ". {FFFFFF}/update ���-�� ��������", 0xFF0000) -- �������� � ����� ������.
                update_found = true -- ���� ���������� �������, ������ ���������� �������� true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update()

    if update_found then                             -- ���� ������� ����������, ������������ ������� /update.
        sampRegisterChatCommand('update', function() -- ���� ������������ ������� �������, ������� ����������.
            update_state = true                      -- ���� ������� �������� /update, ������ ���������.
        end)
    else
        sampAddChatMessage('{FFFFFF}���� ��������� ����������!')
    end

    while true do
        wait(0)

        if update_state then -- ���� ������� ������� /update � ���������� ����, ������� ���������� �������.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(scriptName .. "{FFFFFF}������ {32CD32}������� {FFFFFF}�������.", 0xFF0000)
                end
            end)
            break
        end
    end
end
