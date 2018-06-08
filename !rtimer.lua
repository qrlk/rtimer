script_name("rtimer")
script_version("0.1")
script_author("rubbishman")
script_description("timers")
color = 0xFFFFF
local LIP = {};
local dlstatus = require('moonloader').download_status

local mod_submenus_sa = {
	{
		title = '���������� � �������',
		onclick = function()
			wait(100)
			cmdScriptInfo()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}���������'
	},
	{
		title = '��������� �������',
		submenu = {
			{
				title = '��������/��������� ����������� ��� �������',
				onclick = function()
					cmdScriptInform()
				end
			},
		}
	},
	{
		title = '��������� ������� �����',
		submenu = {
			{
				title = '��������/���������',
				onclick = function()
					lua_thread.create(cmdChangeUgonActive)
				end
			},

			{
				title = '�������� ��������',
				onclick = function()
					lua_thread.create(cmdChangeUgonDelay)
				end
			},
		}
	},
	{
		title = '��������� ������� �����',
		submenu = {
			{
				title = '��������/��������� ������ �����',
				onclick = function()
					lua_thread.create(cmdChangeUsedrugsActive)
				end
			},

			{
				title = '�������� �������� �����',
				onclick = function()
					lua_thread.create(cmdChangeUsedrugsDelay)
				end
			},
			{
				title = '�������� ��������',
				onclick = function()
					sampAddChatMessage("�� ������?", 0xff0000)
				end
			},
			{
				title = '��������/��������� ����',
				onclick = function()
					cmdChangeUsedrugsSoundActive()
				end
			},
			{
				title = ' '
			},
			{
				title = '{AAAAAA}��������� TextDraw'
			},
			{
				title = '��������� "Drugs"',
				submenu = {
					{
						title = '[0] �������� ��� "Drugs"',
						submenu = {
							{
								title = '[0] ������� ��� ������� "Drugs"',
								onclick = function()
									cmdChangeDrugsTxdType(0)
								end
							},
							{
								title = '[1] ������� ��� ������� - "Drugs 150"',
								onclick = function()
									cmdChangeDrugsTxdType(1)
								end
							},
							{
								title = '[2] ������� ��� ������� - "150"',
								onclick = function()
									cmdChangeDrugsTxdType(2)
								end
							},
						},
					},
					{
						title = '[1] �������� ����� "Drugs"',
						submenu = {
							{
								title = '[0] "The San Andreas Font"',
								onclick = function()
									cmdChangeDrugsTxdStyle(0)
								end
							},
							{
								title = '[1] "Both case characters"',
								onclick = function()
									cmdChangeDrugsTxdStyle(1)
								end
							},
							{
								title = '[2] "Only capital letters"',
								onclick = function()
									cmdChangeDrugsTxdStyle(2)
								end
							},
							{
								title = '[3] "�����������"',
								onclick = function()
									cmdChangeDrugsTxdStyle(3)
								end
							},
						},
					},
					{
						title = '[2] �������� ������ "Drugs"',
						submenu = {
							{
								title = '[0] �������� ������� "Drugs"',
								onclick = function()
									cmdChangeDrugsSize(0)
								end
							},
							{
								title = '[1] ������������ ��������� ���������',
								onclick = function()
									cmdChangeDrugsSize(1)
								end
							}
						},
					},
					{
						title = '[3] �������� ���������� "Drugs"',
						submenu = {
							{
								title = '[0] �������� ���������� "Drugs"',
								onclick = function()
									cmdChangeDrugsPos(0)
								end
							},
							{
								title = '[1] ������������ ��������� ���������',
								onclick = function()
									cmdChangeDrugsPos(1)
								end
							}
						},
					},
				}
			},
		}
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}����������'
	},
	{
		title = '������� ����������',
		onclick = function()
			changelog()
		end
	},
	{
		title = '������������� ��������',
		onclick = function()
			lua_thread.create(goupdate)
		end
	},
}

function main()
	while not isSampAvailable() do wait(10) end
	checkversion()
	wait(1000)
	firstload()
	onload()
	if data.options.startmessage == 1 then
		sampAddChatMessage(('RTIMER v'..thisScript().version..' �������. �����: James_Bond, �� �� rubbishman, �� �� Coulson.'),
		0x348cb2)
		sampAddChatMessage(('��������� - /rtimer. ��������� ��� ��������� - /rtimernot'), 0x348cb2)
	end
	lua_thread.create(rtimer)
	usedrugs = lua_thread.create(usedrugs)
	while true do
		wait(0)
		if menutrigger ~= nil then menu() menutrigger = nil end
		-- MAIN
	end
end

function usedrugs()
		data = LIP.load('moonloader\\config\\rtimer.ini');
	if data.usedrugs.isactive == 1 then
		if data.usedrugs.txdtype == 0 then
			sampTextdrawCreate(420, "Drugs", data.usedrugs.posX1, data.usedrugs.posY1)
		end
		if data.usedrugs.txdtype == 1 then
			sampTextdrawCreate(420, "Drugs "..data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
		end
		if data.usedrugs.txdtype == 2 then
			sampTextdrawCreate(420, data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
		end
		usedrugskolvo = lua_thread.create(usedrugskolvo)
		sampTextdrawSetStyle(420, data.usedrugs.style1)
		sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 13447886)
		sampTextdrawSetOutlineColor(420, data.usedrugs.outline1, - 16777216)
		while true do
			wait(0)
			if isKeyJustPressed(data.usedrugs.key) and sampIsDialogActive() == false and sampIsChatInputActive() == false and isPauseMenuActive() == false then
				if os.time() - data.usedrugs.lasttime >= data.usedrugs.cooldown then
					kolvousedrugs = math.ceil((160 - getCharHealth(playerPed)) / 10)
					if kolvousedrugs == 0 then kolvousedrugs = 1 end
					if kolvousedrugs == 16 then kolvousedrugs = 15 end
					sampSendChat("/usedrugs "..kolvousedrugs)
					chat99 = "1"
					while chat99 ~= " ������������ ����������" and chat99 ~= " �� �����!" and chat99 ~= " "..licensenick.." ���������(�) ��������" do
						wait(50)
						print(" "..licensenick.." ���������(�) ��������")
						if chat99 ~= nil then chat99, prefix, color, pcolor = sampGetChatString(99) end
						if chat99 == " "..licensenick.." ���������(�) ��������" then
							data.usedrugs.lasttime = os.time()
							LIP.save('moonloader\\config\\rtimer.ini', data)
							chat99 = nil
							break
						end
					end
				end
			end
			while os.time() < data.usedrugs.lasttime + data.usedrugs.cooldown do
				wait(0)
				sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 65536 )
				sampTextdrawCreate(421, data.usedrugs.lasttime + data.usedrugs.cooldown - os.time(), data.usedrugs.posX2, data.usedrugs.posY2)
				sampTextdrawSetStyle(421, data.usedrugs.style2)
				sampTextdrawSetLetterSizeAndColor(421, data.usedrugs.size3, data.usedrugs.size4, - 13447886)
				sampTextdrawSetOutlineColor(421, data.usedrugs.outline2, - 16777216)
				if isKeyDown(data.usedrugs.key) then
					wait(1500)
					if wasKeyReleased(data.usedrugs.key) == false then sampSendChat('/usedrugs 1') wait(1500) end
				end
				if data.usedrugs.lasttime + data.usedrugs.cooldown <= os.time() then
					sampTextdrawDelete(421)
					if data.usedrugs.sound == 1 then addOneOffSound(0.0, 0.0, 0.0, 1057) end
					sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 13447886)
					LIP.save('moonloader\\config\\rtimer.ini', data)
				end
			end
		end
	end
end


function usedrugskolvo()
	while true do
		wait(0)
		chat98, prefix, color, pcolor = sampGetChatString(98)
		if string.find(chat98, "(( �������:", 1, true) then
			if string.match(chat98, "(%d+)") ~= data.usedrugs.kolvo and string.match(chat98, "(%d+)") ~= nil then
				data.usedrugs.kolvo = string.match(chat98, "(%d+)")
				LIP.save('moonloader\\config\\rtimer.ini', data)
				if data.usedrugs.txdtype == 1 then
					sampTextdrawCreate(420, "Drugs "..data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
					sampTextdrawSetStyle(420, data.usedrugs.style1)
					if os.time() < data.usedrugs.lasttime + data.usedrugs.cooldown then
						sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 65536 )
					else
						sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 13447886)
					end
					sampTextdrawSetOutlineColor(420, data.usedrugs.outline1, - 16777216)
				end
				if data.usedrugs.txdtype == 2 then
					sampTextdrawCreate(420, data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
					sampTextdrawSetStyle(420, data.usedrugs.style1)
					if os.time() < data.usedrugs.lasttime + data.usedrugs.cooldown then
						sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 65536 )
					else
						sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 13447886)
					end
					sampTextdrawSetOutlineColor(420, data.usedrugs.outline1, - 16777216)
				end
				chat98 = nil
				if chat98 == nil then
					wait(3000)
					chat98, prefix, color, pcolor = sampGetChatString(98)
				end
			end
		end
	end
end

function clear()
	sampTextdrawDelete(420)
	sampTextdrawDelete(421)
end


function rtimer()
	while true do
		wait(0)
		if data.ugon.isactive == 1 then
			chat, prefix, color, pcolor = sampGetChatString(99)
			if chat == "��������� - /rtimer. ��������� ��� ��������� - /rtimernot" and stopugon == nil then
				data.ugon.lasttime = os.time()
				data.ugon.count = data.ugon.count + 1
				data.ugon.notif = 0
				stopugon = 1
				LIP.save('moonloader\\config\\rtimer.ini', data)
			end
			if data.ugon.notif == 0 then
				if data.ugon.lasttime + data.ugon.cooldown <= os.time() then
					sampAddChatMessage("��� ������, ��������", 0xFFFFF)
					stopugon = nil
					data.ugon.notif = 1
					LIP.save('moonloader\\config\\rtimer.ini', data)
					wait(1000)
				end
			end
		end
	end
end

-- ������� firsload() �������� �� �������� .ini ��� ������ �������.
function firstload()
	if not doesDirectoryExist("moonloader\\config") then createDirectory("moonloader\\config") end
	if not doesFileExist("moonloader\\config\\rtimer.ini") then
		local data =
		{
			options =
			{
				startmessage = 1,
			},
			ugon =
			{
				lasttime = 1,
				isactive = 1,
				count = 0,
				cooldown = 900,
				notif = 0,
			},
			usedrugs =
			{
				lasttime = 1,
				isactive = 1,
				kolvo = "???",
				sound = 1,
				txdtype = 1,
				--[Wait]
				cooldown = 60,
				--[DrugsPos]
				posX1 = 56,
				posY1 = 424,
				--[DrugsSize]
				size1 = 0.6,
				size2 = 1.2,
				--[DrugsStyle]
				style1 = 3,
				--[TimerPos]
				posX2 = 80,
				posY2 = 315,
				--[TimerSize]
				size3 = 0.4,
				size4 = 2,
				--[TimerStyle]
				style2 = 3,
				--[DrugsOutline]
				outline1 = 1,
				--[TimerOutline]
				outline2 = 1,
				--[KEY]
				key = 88,
			},
		};
		LIP.save('moonloader\\config\\rtimer.ini', data);
		sampAddChatMessage(('������ ������ RTIMER. ��� ������ .ini: moonloader\\config\\rtimer.ini'), 0x348cb2)
		sampAddChatMessage(('�������� ���� �� Samp-Rp! � ����������, ����� Samp-Rp Revolution James_Bond!'), 0x348cb2)
	end
end
--������� onload() �������� �� �������� ������� ����� ��� ������������
function onload()
	data = LIP.load('moonloader\\config\\rtimer.ini');
	data.usedrugs.lasttime = 0
	asodkas, licenseid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	licensenick = sampGetPlayerNickname(licenseid)
	LIP.save('moonloader\\config\\rtimer.ini', data);
	sampRegisterChatCommand('rtimernot', cmdScriptInform)
	sampRegisterChatCommand('rtimer', scriptmenu)
	sampRegisterChatCommand('rtimerlog', changelog)
	sampRegisterChatCommand('ugon', ugontimer)
	sampRegisterChatCommand('clear', clear)
	sampRegisterChatCommand('test', test)
end

function test()
	lua_thread.create(cmdChangeDrugsSize, 0)
end

function ugontimer()
	if data.ugon.isactive == 1 then
		ugondown = data.ugon.lasttime + data.ugon.cooldown - os.time()
		if ugondown <= 0 then sampAddChatMessage("��� �����", 0xFFFFF) end
		if ugondown > 0 then
			if ugondown < 61 then sampAddChatMessage("��������: "..ugondown.." ������.", 0xFFFFF)
			else
				ugonminute = math.floor(ugondown / 60)
				ugonsec = ugondown % 60
				sampAddChatMessage("��������: "..ugonminute.." �����, "..ugonsec.." ������.", 0xFFFFF)
			end
		end
	end
end


function cmdScriptInfo()
	sampShowDialog(2342, "{348cb2}RTIMER v"..thisScript().version..". �����: James_Bond/rubbishman/Coulson.", "{ffcc00}����� ���� ������?\n{ffffff}� ����� ������������ ������ ��������� ���������?\n��� ���� ���� ������� ����� � ����������? �����������, ��� ����� � ���������� 2.0! \n�������� ��� \"� ���\" � \"� ���\", � ���� �������� �� ����� ������� �����, ����� ���������, ��� ��.\n{ffcc00}��� ������ ��������?\n{ffffff}���� ��� ������ ������ GLONASS{ffffff}: {348cb2}�������{ffffff} � {348cb2}����������{ffffff}.\n{348cb2} ������� �����:{ffffff}\n��� ������� ������ � /f ����� �������� ���� ������� ����������. \n� ���������� �������� ����� �� ��� �����������, ������� �� ��������.\n����� ����� �� ������ �� ������, �� � � ���� ������, ������� ����� ����� ������� ��� ������.\n{348cb2}  ���������� �����:\n{ffffff}��� ���������� �� �� �� �����, �� ���������� �������, ������� ����� ��������� ���� \n���������� ������ 3-7 ������. ���������� ����� ���������� ��� ������ � ����������.\n����� ���������� ���� � ���, �������� ��� �� ����� � ���� ������ ������ ��� ������� {00ccff}/glean{ffffff}.\n{ffcc00}��� ��� �������?\n{ffffff}������� {00ccff}P{ffffff}, ����� ������� ���� ������. \n����� ���� ������ �� ��������� ��������� ��� ��������: �������� ���������, �����������, \n�������, ����������, ����� ������ � ��� �����.\n����� ������� ������ ��� ������ � ���������, ��� � ��������� 1-9 (��� ������� �������).\n{ffcc00}��� ��� �������?\n{ffffff}������� {00ccff}Z{ffffff}, ����� ������ ������� ��������� �����. \n{ffffff}������� {00ccff}]{ffffff}, ����� ������� ����, ����������� ���� ������.\n����� ������� �����/��������� ����������� ����������, �������� ��� �� ����� � ���� \n�������� ��� ������� {00ccff}/glean{ffffff}.\nGLONASS ����������� ��� �� ��������� �������� � ���� � ����� ������� ����� �� �������.\n{ffcc00}��������� �������:\n    {00ccff}/glonass {ffffff}- ���� �������\n    {00ccff}/glean {ffffff}- ������� �����, ������ � ���������� �������� ��������\n    {00ccff}/glonasslog {ffffff}- changelog �������\n{00ccff}    /glonassnot{ffffff} - ��������/��������� ��������� ��� ����� � ����", "����")
end
function changelog()
	sampShowDialog(2342, "{348cb2}RTIMER: ������� ������.", "{ffcc00}v1.0 [XX.10.17]\n{ffffff}������ ����� �������.", "�������")
end

-- DO NOT TOUCH
-- ��������� �����
function cmdChangeUgonDelay()
	sampShowDialog(989, "��������� ��������", string.format("������� �������� � ��������.\n������� ��������: "..data.ugon.cooldown.." ���."), "�������", "�������", 1)
	while sampIsDialogActive() do wait(100) end
	if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
		data.ugon.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
		LIP.save('moonloader\\config\\rtimer.ini', data)
	end
end
function cmdChangeUgonActive()
	if data.ugon.isactive == 1 then data.ugon.isactive = 0 sampAddChatMessage('������ ����� ��������.', 0xFFFFF) else data.ugon.isactive = 1 sampAddChatMessage('������ ����� �������.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
-- ��������� usedrugs
function cmdChangeUsedrugsDelay()
	sampShowDialog(989, "��������� �������� �����", string.format("������� �������� � ��������.\n������� ��������: "..data.usedrugs.cooldown.." ���."), "�������", "�������", 1)
	while sampIsDialogActive() do wait(100) end
	if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
		data.usedrugs.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
		LIP.save('moonloader\\config\\rtimer.ini', data)
	end
end
function cmdChangeUsedrugsActive()
	if data.usedrugs.isactive == 1 then data.usedrugs.isactive = 0 sampAddChatMessage('������ ����� ��������.', 0xFFFFF) else data.usedrugs.isactive = 1 sampAddChatMessage('������ ����� �������.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
function cmdChangeUsedrugsSoundActive()
	if data.usedrugs.sound == 1 then data.usedrugs.sound = 0 sampAddChatMessage('���� ������� ����� ��������.', 0xFFFFF) else data.usedrugs.sound = 1 sampAddChatMessage('���� ������� ����� �������.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
function cmdChangeDrugsTxdType(param)
	local txdtype = tonumber(param)
	if txdtype == 0 then data.usedrugs.txdtype = 0 sampAddChatMessage('������ ��� ������� "Drugs" [0]', 0xFFFFF) end
	if txdtype == 1 then data.usedrugs.txdtype = 1 sampAddChatMessage('������ ��� ������� "Drugs 150" [1]', 0xFFFFF) end
	if txdtype == 2 then data.usedrugs.txdtype = 2 sampAddChatMessage('������ ��� ������� "150" [2]', 0xFFFFF) end
	LIP.save('moonloader\\config\\rtimer.ini', data)
	usedrugs:terminate()
	usedrugskolvo:terminate()
	usedrugs:run()
end
function cmdChangeDrugsPos(param)
	local drugspostype = tonumber(param)
	if drugspostype == 0 then
		local bckpX1 = data.usedrugs.posX1
		local bckpY1 = data.usedrugs.posY1
		sampShowDialog(3838, "��������� ��������� TextDraw'a", "�������� ���������� ����� � ������� ���������.\n����� ������� ����������, ������� \"Enter\".\n����� ��������, ������� ������.\n� ���� ����� ������������ �����������.", "� �����")
		while sampIsDialogActive(3838) == true do wait(100) end
		while true do
			wait(0)
			if bckpY1 > 0 and bckpY1 < 480 and bckpX1 > 0 and bckpX1 < 640 then
				wait(0)
				if isKeyDown(40) and bckpY1 + 1 < 480 then bckpY1 = bckpY1 + 1 end
				if isKeyDown(38) and bckpY1 - 1 > 0 then bckpY1 = bckpY1 - 1 end
				if isKeyDown(37) and bckpX1 - 1 > 0 then bckpX1 = bckpX1 - 1 end
				if isKeyDown(39) and bckpX1 + 1 < 640 then bckpX1 = bckpX1 + 1 end
				if data.usedrugs.isactive == 1 then
					if data.usedrugs.txdtype == 0 then
						sampTextdrawCreate(420, "Drugs", bckpX1, bckpY1)
					end
					if data.usedrugs.txdtype == 1 then
						sampTextdrawCreate(420, "Drugs "..data.usedrugs.kolvo, bckpX1, bckpY1)
					end
					if data.usedrugs.txdtype == 2 then
						sampTextdrawCreate(420, data.usedrugs.kolvo, bckpX1, bckpY1)
					end
					sampTextdrawSetStyle(420, data.usedrugs.style1)
					sampTextdrawSetLetterSizeAndColor(420, data.usedrugs.size1, data.usedrugs.size2, - 13447886)
					sampTextdrawSetOutlineColor(420, data.usedrugs.outline1, - 16777216)
				end
				if isKeyJustPressed(13) then
					data.usedrugs.posX1 = bckpX1
					data.usedrugs.posY1 = bckpY1
					addOneOffSound(0.0, 0.0, 0.0, 1052)
					LIP.save('moonloader\\config\\rtimer.ini', data)
					usedrugs:terminate()
					usedrugskolvo:terminate()
					usedrugs:run()
					break
				end
				if isKeyJustPressed(32) then
					addOneOffSound(0.0, 0.0, 0.0, 1053)
					usedrugs:terminate()
					usedrugskolvo:terminate()
					usedrugs:run()
					break
				end
			end
		end
	end
	if drugspostype == 1 then
		data.usedrugs.posX1 = 56
		data.usedrugs.posY1 = 424
		addOneOffSound(0.0, 0.0, 0.0, 1052)
		LIP.save('moonloader\\config\\rtimer.ini', data)
		usedrugs:terminate()
		usedrugskolvo:terminate()
		usedrugs:run()
	end
end

function cmdChangeDrugsSize(param)
	local drugssizetype = tonumber(param)
	if drugssizetype == 0 then
		local bckpS1 = data.usedrugs.size1
		local bckpS2 = data.usedrugs.size2
		sampShowDialog(3838, "��������� ������� TextDraw'a", "�������� ������ ����� � ������� ��������� �����-����.\n����� ������� ������, ������� \"Enter\".\n����� ��������, ������� ������.\n� ���� ����� ������������ �����������.", "� �����")
		while sampIsDialogActive(3838) == true do wait(100) end
		while true do
			wait(0)
			if bckpS1 > 0 and bckpS2 > 0 then
				wait(0)
				if isKeyDown(40) and bckpS1 - 0.1 > 0 and bckpS2 - 0.1 > 0 then
					bckpS1 = bckpS1 - 0.1
					bckpS2 = bckpS1 *2
				end
				if isKeyDown(38) and bckpS1 - 0.1 > 0 and bckpS2 - 0.1 > 0 then
					bckpS1 = bckpS1 + 0.1
					bckpS2 = bckpS1 *2
				end
				if data.usedrugs.isactive == 1 then
					if data.usedrugs.txdtype == 0 then
						sampTextdrawCreate(420, "Drugs", data.usedrugs.posX1, data.usedrugs.posY1)
					end
					if data.usedrugs.txdtype == 1 then
						sampTextdrawCreate(420, "Drugs "..data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
					end
					if data.usedrugs.txdtype == 2 then
						sampTextdrawCreate(420, data.usedrugs.kolvo, data.usedrugs.posX1, data.usedrugs.posY1)
					end
					sampTextdrawSetStyle(420, data.usedrugs.style1)
					sampTextdrawSetLetterSizeAndColor(420, bckpS1, bckpS2, - 13447886)
					sampTextdrawSetOutlineColor(420, data.usedrugs.outline1, - 16777216)
					if isKeyJustPressed(13) then
						data.usedrugs.size1 = bckpS1
						data.usedrugs.size2 = bckpS2
						addOneOffSound(0.0, 0.0, 0.0, 1052)
						LIP.save('moonloader\\config\\rtimer.ini', data)
						usedrugs:terminate()
						usedrugskolvo:terminate()
						usedrugs:run()
						break
					end
					if isKeyJustPressed(32) then
						addOneOffSound(0.0, 0.0, 0.0, 1053)
						sampAddChatMessage("tst", color)
						usedrugs:terminate()
						usedrugskolvo:terminate()
						usedrugs:run()
						sampAddChatMessage("tst", color)
						break
					end
				end
			end
		end
	end
	if drugssizetype == 1 then
		data.usedrugs.size1 = 0.6
		data.usedrugs.size2 = 1.2
		addOneOffSound(0.0, 0.0, 0.0, 1052)
		LIP.save('moonloader\\config\\rtimer.ini', data)
		usedrugs:terminate()
		usedrugskolvo:terminate()
		usedrugs:run()
	end
end
function cmdChangeDrugsTxdStyle(param)
	local txdstyle = tonumber(param)
	data.usedrugs.style1 = txdstyle
	addOneOffSound(0.0, 0.0, 0.0, 1052)
	LIP.save('moonloader\\config\\rtimer.ini', data)
	usedrugs:terminate()
	usedrugskolvo:terminate()
	usedrugs:run()
end
--render txdtype
-- DO NOT TOUCH
function menu()
	submenus_show(mod_submenus_sa, '{348cb2}RTIMER v'..thisScript().version..'', '�������', '�������', '�����')
end
function scriptmenu()
	menutrigger = 1
end
-- ������� ��������/��������� �����������
function cmdScriptInform()
	if data.options.startmessage == 1 then
		data.options.startmessage = 0 sampAddChatMessage(('����������� ��������� RTIMER ��� ������� ���� ���������'), 0x348cb2)
	else
		data.options.startmessage = 1 sampAddChatMessage(('����������� ��������� RTIMER ��� ������� ���� ��������'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data);
	data = LIP.load('moonloader\\config\\rtimer.ini');
end
-- DO NOT TOUCH
function onScriptTerminate(LuaScript, bool)
	if LuaScript == thisScript() and bool == false then
		sampTextdrawDelete(421)
		sampTextdrawDelete(420)
	end
end
-- DO NOT TOUCH
--������� LIP.load() �������� �� �������� .ini
function LIP.load(fileName)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	local file = assert(io.open(fileName, 'r'), 'Error loading file : ' .. fileName);
	local data = {};
	local section;
	for line in file:lines() do
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection)then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = value;
		end
	end
	file:close();
	return data;
end
--������� LIP.save() �������� �� ���������� .ini
function LIP.save(fileName, data)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	assert(type(data) == 'table', 'Parameter "data" must be a table.');
	local file = assert(io.open(fileName, 'w+b'), 'Error loading file :' .. fileName);
	local contents = '';
	for section, param in pairs(data) do
		contents = contents .. ('[%s]\n'):format(section);
		for key, value in pairs(param) do
			contents = contents .. ('%s=%s\n'):format(key, tostring(value));
		end
		contents = contents .. '\n';
	end
	file:write(contents);
	file:close();
end
function submenus_show(menu, caption, select_button, close_button, back_button)
	select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
	prev_menus = {}
	function display(menu, id, caption)
		local string_list = {}
		for i, v in ipairs(menu) do
			table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
		end
		sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
		repeat
			wait(0)
			local result, button, list = sampHasDialogRespond(id)
			if result then
				if button == 1 and list ~= -1 then
					local item = menu[list + 1]
					if type(item.submenu) == 'table' then -- submenu
						table.insert(prev_menus, {menu = menu, caption = caption})
						if type(item.onclick) == 'function' then
							item.onclick(menu, list + 1, item.submenu)
						end
						return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
					elseif type(item.onclick) == 'function' then
						local result = item.onclick(menu, list + 1)
						if not result then return result end
						return display(menu, id, caption)
					end
				else -- if button == 0
					if #prev_menus > 0 then
						local prev_menu = prev_menus[#prev_menus]
						prev_menus[#prev_menus] = nil
						return display(prev_menu.menu, id - 1, prev_menu.caption)
					end
					return false
				end
			end
		until result
	end
	return display(menu, 31337, caption or menu.title)
end
function checkversion()
	goplay = 0
	local fpath = os.getenv('TEMP') .. '\\rtimer-version.json'
	downloadUrlToFile('http://rubbishman.ru/dev/samp/rtimer/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
		local f = io.open(fpath, 'r')
		if f then
			local info = decodeJson(f:read('*a'))
			updatelink = info.updateurl
			if info and info.latest then
				version = tonumber(info.latest)
				if version > tonumber(thisScript().version) then
					sampAddChatMessage(('[RTIMER]: ���������� ����������. AutoReload ����� �������������. ����������..'), 0x8B0000)
					sampAddChatMessage(('[RTIMER]: ������� ������: '..thisScript().version..". ����� ������: "..version), 0x8B0000)
					goplay = 2
					lua_thread.create(goupdate)
				end
			end
		end
	end
end)
wait(1000)
if goplay ~= 2 then goplay = 1 end
end
function goupdate()
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
	if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	sampAddChatMessage(('[RTIMER]: ���������� ���������! ��������� �� ���������� - /glonasslog.'), 0x8B0000)
	goplay = 1
	thisScript():reload()
end
end)
end
