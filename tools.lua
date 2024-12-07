script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version("1")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require('moonloader').download_status

update_state = false -- ���� ���������� == true, ������ ������� ����������.
update_found = false -- ���� ����� true, ����� �������� ������� /update.

local script_vers = 1
local script_vers_text =
"1.0" -- �������� ����� ������. � ������� ����� � �������� �����������.

local update_url =
'https://www.dropbox.com/scl/fi/1mifj2d4jorajt7h8x00z/update.ini?rlkey=i9gtvifpq77ovdviyykofkyoa&st=6h1bmzqo&dl=0' -- ���� � ini �����. ����� ��� ������������.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url =
'https://www.dropbox.com/scl/fi/v9viclmaf7utsu1hqwlew/tools.lua?rlkey=y7nur7pnzh1t7imu7ptnmnb1u&st=v9m88tj0&dl=0' -- ���� �������.
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
