script_name("LunaTools")
script_author("HermitTech")
script_description("Luna Tools. Vers. 1")
script_version('2')

scriptName = "{8B59FF}[ Luna Tools ]{FFFFFF}"
betaScriptName = "[ Luna | DeBug ]"
scriptVersion = "1a"

require 'lib.moonloader'
local encoding = require 'encoding'
local requests = require 'requests'
local dlstatus = require('moonloader').download_status

encoding.default = 'CP1251'
u8 = encoding.UTF8

function update()
    local raw = 'https://raw.githubusercontent.com/XakerTv/moontools/refs/heads/main/updater.json'
    local f = {}

    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end

    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function(id, status, p1, p2)
                print('�������� ' .. decodeJson(response.text)['url'] .. ' � ' .. thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('������ ��������, ������������...', -1)
                    thisScript():reload()
                    sampAddChatMessage(scriptName .. '==============����������' .. scriptVersion .. '==============',
                        0x8B59FF)
                    sampAddChatMessage(scriptName .. '* ���������: *', -1)
                    sampAddChatMessage(scriptName .. '- ������� ��������������', -1)
                end
            end)
        else
            sampAddChatMessage('������, ���������� ���������� ����������, ���: ' .. response.status_code, -1)
        end
    end

    return f
end

function main()
    while not isSampAvailable() do wait(0) end

    -- ��������������
    local updater = update()
    local lastVersion = updater:getLastVersion()
    if lastVersion ~= script_version() then
        sampAddChatMessage(scriptName .. " �������� ����� ������ �������: " .. lastVersion, 0xFFFF00)
        updater:download()
        return
    end

    -- �������� ����������������
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    sampAddChatMessage(scriptName .. " ������ ����� � ������.", 0xFFFFFF)
    sampAddChatMessage(scriptName .. " � ������������, " .. nick, 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������� ������� ����: /mtools", 0xFFFFFF)
    sampAddChatMessage(betaScriptName .. " ������ �������: " .. scriptVersion, 0xBFBFBF)

    while true do
        wait(0)
    end
end
