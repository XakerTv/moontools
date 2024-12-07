script_name('MoonTools')
script_author('Tech')
script_description('AutoUpdate')
script_version('1')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
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

-- ������� ��� �������� � ���������� ���������
function downloadWithRetry(url, path, retries, delay)
    local attempt = 1

    local function tryDownload()
        if attempt > retries then
            sampAddChatMessage(scriptName .. "������ �������� ����� " .. retries .. " �������.", 0xFF0000)
            return false
        end

        sampAddChatMessage(scriptName .. "������� �������� " .. attempt .. "...", 0xFFFFFF)
        downloadUrlToFile(url, path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage(scriptName .. "���� ������� ��������.", 0x00FF00)
                return true
            else
                sampAddChatMessage(scriptName .. "������ ��������. ������: " .. tostring(status), 0xFF0000)
                attempt = attempt + 1
                lua_thread.create(function()
                    wait(delay)   -- �������� ����� ��������� ��������
                    tryDownload() -- ����������� �����
                end)
            end
        end)
    end

    tryDownload() -- �������� ������ �������
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('update', cmd_update)

    local success, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if not success then
        sampAddChatMessage(scriptName .. '������ ��������� ID ������.', 0xFF0000)
        return
    end
    local nick = sampGetPlayerNickname(id)
    sampAddChatMessage(scriptName .. " ������ ����� � ������.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " � ������������, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������� ������� ����: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������ �������: " .. scriptVersion, 0xBFBFBF)

    while true do
        wait(0)
    end
end

function cmd_update()
    sampAddChatMessage(scriptName .. '�������� ����������...', 0xFFFFFF)

    -- ������� ��������� ���� update.ini, ���� �� ����������
    if doesFileExist(update_path) then
        local success = os.remove(update_path)
        if not success then
            sampAddChatMessage(scriptName .. '������ �������� update.ini.', 0xFF0000)
            return
        end
    end

    -- ��������� ���� update.ini � ������ �������
    local success = downloadWithRetry(update_url, update_path, 3, 500)
    if not success then
        sampAddChatMessage(scriptName .. "������ �������� update.ini ����� ���������� �������.", 0xFF0000)
        return
    end

    -- ��������� ini-����
    local updateIni = inicfg.load(nil, update_path)

    -- ���������, �������� �� ini-����
    if not updateIni then
        sampAddChatMessage(scriptName .. '������: �� ������� ��������� update.ini.', 0xFF0000)
        os.remove(update_path)
        return
    end

    -- ���������� �������� �� ������� ������ [info] � ����� vers/vers_text
    if not updateIni.info or not updateIni.info.vers or not updateIni.info.vers_text then
        sampAddChatMessage(scriptName .. '������: update.ini �������� ��� ����� �������� ������.', 0xFF0000)
        os.remove(update_path)
        return
    end

    -- ��������� ������
    if tonumber(updateIni.info.vers) > script_vers then
        sampAddChatMessage(scriptName .. '������� ����������! ������: ' .. updateIni.info.vers_text, -1)

        -- ������� ������ ������, ���� �� ����������
        if doesFileExist(script_path) then
            local success = os.remove(script_path)
            if not success then
                sampAddChatMessage(scriptName .. '������ �������� ������� �������.', 0xFF0000)
                return
            end
        end

        -- ��������� ����� ������
        downloadUrlToFile(script_url, script_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage(scriptName .. '������ ������� ��������!', -1)
                sampAddChatMessage(scriptName .. '========================����������========================', -1)
                sampAddChatMessage(scriptName .. '���������:', -1)
                sampAddChatMessage(scriptName .. '- �������������� �������', -1)
                thisScript():reload()
            else
                sampAddChatMessage(
                    scriptName .. '������ �������� ������ �������. ��� �������: ' .. tostring(status), 0xFF0000)
            end
        end)
    else
        sampAddChatMessage(scriptName .. '���������� �� �������. ������� ������: ' .. script_vers_text, 0xFFFFFF)
    end

    -- ������� ��������� ���� update.ini
    os.remove(update_path)
end
