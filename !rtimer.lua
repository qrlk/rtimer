script_name("rtimer")
script_version("0.1")
script_author("rubbishman")
script_description("timers")
color = 0xFFFFF
local LIP = {};
local dlstatus = require('moonloader').download_status

local mod_submenus_sa = {
	{
		title = 'Информация о скрипте',
		onclick = function()
			wait(100)
			cmdScriptInfo()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}Настройки'
	},
	{
		title = 'Настройки скрипта',
		submenu = {
			{
				title = 'Включить/выключить уведомление при запуске',
				onclick = function()
					cmdScriptInform()
				end
			},
		}
	},
	{
		title = 'Настройки таймера угона',
		submenu = {
			{
				title = 'Включить/выключить',
				onclick = function()
					lua_thread.create(cmdChangeUgonActive)
				end
			},

			{
				title = 'Изменить задержку',
				onclick = function()
					lua_thread.create(cmdChangeUgonDelay)
				end
			},
		}
	},
	{
		title = 'Настройки таймера нарко',
		submenu = {
			{
				title = 'Включить/выключить таймер нарко',
				onclick = function()
					lua_thread.create(cmdChangeUsedrugsActive)
				end
			},

			{
				title = 'Изменить задержку нарко',
				onclick = function()
					lua_thread.create(cmdChangeUsedrugsDelay)
				end
			},
			{
				title = 'Включить автосбив',
				onclick = function()
					sampAddChatMessage("Ты долбоёб?", 0xff0000)
				end
			},
			{
				title = 'Включить/выключить звук',
				onclick = function()
					cmdChangeUsedrugsSoundActive()
				end
			},
			{
				title = ' '
			},
			{
				title = '{AAAAAA}Настройки TextDraw'
			},
			{
				title = 'Настройки "Drugs"',
				submenu = {
					{
						title = '[0] Изменить тип "Drugs"',
						submenu = {
							{
								title = '[0] Выбрать тип оверлея "Drugs"',
								onclick = function()
									cmdChangeDrugsTxdType(0)
								end
							},
							{
								title = '[1] Выбрать тип оверлея - "Drugs 150"',
								onclick = function()
									cmdChangeDrugsTxdType(1)
								end
							},
							{
								title = '[2] Выбрать тип оверлея - "150"',
								onclick = function()
									cmdChangeDrugsTxdType(2)
								end
							},
						},
					},
					{
						title = '[1] Изменить стиль "Drugs"',
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
								title = '[3] "Стандартный"',
								onclick = function()
									cmdChangeDrugsTxdStyle(3)
								end
							},
						},
					},
					{
						title = '[2] Изменить размер "Drugs"',
						submenu = {
							{
								title = '[0] Изменить размеры "Drugs"',
								onclick = function()
									cmdChangeDrugsSize(0)
								end
							},
							{
								title = '[1] Восстановить дефолтные настройки',
								onclick = function()
									cmdChangeDrugsSize(1)
								end
							}
						},
					},
					{
						title = '[3] Изменить координаты "Drugs"',
						submenu = {
							{
								title = '[0] Изменить координаты "Drugs"',
								onclick = function()
									cmdChangeDrugsPos(0)
								end
							},
							{
								title = '[1] Восстановить дефолтные настройки',
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
		title = '{AAAAAA}Обновления'
	},
	{
		title = 'История обновлений',
		onclick = function()
			changelog()
		end
	},
	{
		title = 'Принудительно обновить',
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
		sampAddChatMessage(('RTIMER v'..thisScript().version..' запущен. Автор: James_Bond, он же rubbishman, он же Coulson.'),
		0x348cb2)
		sampAddChatMessage(('Подробнее - /rtimer. Отключить это сообщение - /rtimernot'), 0x348cb2)
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
					while chat99 ~= " Недостаточно наркотиков" and chat99 ~= " Не флуди!" and chat99 ~= " "..licensenick.." употребил(а) наркотик" do
						wait(50)
						print(" "..licensenick.." употребил(а) наркотик")
						if chat99 ~= nil then chat99, prefix, color, pcolor = sampGetChatString(99) end
						if chat99 == " "..licensenick.." употребил(а) наркотик" then
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
		if string.find(chat98, "(( Остаток:", 1, true) then
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
			if chat == "Подробнее - /rtimer. Отключить это сообщение - /rtimernot" and stopugon == nil then
				data.ugon.lasttime = os.time()
				data.ugon.count = data.ugon.count + 1
				data.ugon.notif = 0
				stopugon = 1
				LIP.save('moonloader\\config\\rtimer.ini', data)
			end
			if data.ugon.notif == 0 then
				if data.ugon.lasttime + data.ugon.cooldown <= os.time() then
					sampAddChatMessage("Иди угоняй, животное", 0xFFFFF)
					stopugon = nil
					data.ugon.notif = 1
					LIP.save('moonloader\\config\\rtimer.ini', data)
					wait(1000)
				end
			end
		end
	end
end

-- Функция firsload() отвечает за создание .ini при первом запуске.
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
		sampAddChatMessage(('Первый запуск RTIMER. Был создан .ini: moonloader\\config\\rtimer.ini'), 0x348cb2)
		sampAddChatMessage(('Приятной игры на Samp-Rp! С презрением, игрок Samp-Rp Revolution James_Bond!'), 0x348cb2)
	end
end
--Функция onload() отвечает за загрузку скрипта перед его выполенением
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
		if ugondown <= 0 then sampAddChatMessage("Уже можно", 0xFFFFF) end
		if ugondown > 0 then
			if ugondown < 61 then sampAddChatMessage("Осталось: "..ugondown.." секунд.", 0xFFFFF)
			else
				ugonminute = math.floor(ugondown / 60)
				ugonsec = ugondown % 60
				sampAddChatMessage("Осталось: "..ugonminute.." минут, "..ugonsec.." секунд.", 0xFFFFF)
			end
		end
	end
end


function cmdScriptInfo()
	sampShowDialog(2342, "{348cb2}RTIMER v"..thisScript().version..". Автор: James_Bond/rubbishman/Coulson.", "{ffcc00}Зачем этот скрипт?\n{ffffff}А зачем человечество веками осваивало навигацию?\nДля чего была создана карта с квадратами? Знакомьтесь, это карта с квадратами 2.0! \nЗабудьте про \"я там\" и \"я тут\", с этим скриптом не нужно тратить время, чтобы объяснить, где вы.\n{ffcc00}Как скрипт работает?\n{ffffff}Есть два режима работы GLONASS{ffffff}: {348cb2}обычный{ffffff} и {348cb2}динамичный{ffffff}.\n{348cb2} Обычный режим:{ffffff}\nПри обычном режиме в /f будут переданы ваши текущие координаты. \nУ принявшего появится метка на тех координатах, которые вы передали.\nМетка будет не только на радаре, но и в виде пикапа, который можно взять машиной или пешком.\n{348cb2}  Динамичный режим:\n{ffffff}При динамичном всё то же самое, но запустится процесс, который будет обновлять ваши \nкоординаты каждые 3-7 секунд. Динамичный режим создавался для погонь и перехватов.\nЧтобы остановить флуд в чат, выберите тот же пункт в меню вызова помощи или введите {00ccff}/glean{ffffff}.\n{ffcc00}Как мне ВЫЗВАТЬ?\n{ffffff}Нажмите {00ccff}P{ffffff}, чтобы открыть меню вызова. \nПеред вами список из возможных сценариев для байкеров: передача координат, перестрелка, \nматовоз, ограбление, режим погони и так далее.\nМожно выбрать нужный как мышкой и стрелками, так и клавишами 1-9 (так намного быстрее).\n{ffcc00}Как мне ПРИНЯТЬ?\n{ffffff}Нажмите {00ccff}Z{ffffff}, чтобы быстро принять последний вызов. \n{ffffff}Нажмите {00ccff}]{ffffff}, чтобы открыть меню, аналогичное меню вызова.\nЧтобы удалить метки/перестать отслеживать координаты, выберите тот же пункт в меню \nпринятия или введите {00ccff}/glean{ffffff}.\nGLONASS отслеживает так же написание квадрата в чате и умеет ставить метку на квадрат.\n{ffcc00}Доступные команды:\n    {00ccff}/glonass {ffffff}- меню скрипта\n    {00ccff}/glean {ffffff}- удалить метки, пикапы и остановить процессы слежения\n    {00ccff}/glonasslog {ffffff}- changelog скрипта\n{00ccff}    /glonassnot{ffffff} - включить/выключить сообщение при входе в игру", "Лады")
end
function changelog()
	sampShowDialog(2342, "{348cb2}RTIMER: История версий.", "{ffcc00}v1.0 [XX.10.17]\n{ffffff}Первый релиз скрипта.", "Закрыть")
end

-- DO NOT TOUCH
-- настройки угона
function cmdChangeUgonDelay()
	sampShowDialog(989, "Установка задержки", string.format("Введите задержку в секундах.\nТекущая задержка: "..data.ugon.cooldown.." сек."), "Выбрать", "Закрыть", 1)
	while sampIsDialogActive() do wait(100) end
	if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
		data.ugon.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
		LIP.save('moonloader\\config\\rtimer.ini', data)
	end
end
function cmdChangeUgonActive()
	if data.ugon.isactive == 1 then data.ugon.isactive = 0 sampAddChatMessage('Таймер угона выключен.', 0xFFFFF) else data.ugon.isactive = 1 sampAddChatMessage('Таймер угона включен.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
-- настройки usedrugs
function cmdChangeUsedrugsDelay()
	sampShowDialog(989, "Установка задержки нарко", string.format("Введите задержку в секундах.\nТекущая задержка: "..data.usedrugs.cooldown.." сек."), "Выбрать", "Закрыть", 1)
	while sampIsDialogActive() do wait(100) end
	if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
		data.usedrugs.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
		LIP.save('moonloader\\config\\rtimer.ini', data)
	end
end
function cmdChangeUsedrugsActive()
	if data.usedrugs.isactive == 1 then data.usedrugs.isactive = 0 sampAddChatMessage('Таймер нарко выключен.', 0xFFFFF) else data.usedrugs.isactive = 1 sampAddChatMessage('Таймер нарко включен.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
function cmdChangeUsedrugsSoundActive()
	if data.usedrugs.sound == 1 then data.usedrugs.sound = 0 sampAddChatMessage('Звук таймера нарко выключен.', 0xFFFFF) else data.usedrugs.sound = 1 sampAddChatMessage('Звук таймера нарко включен.', 0xFFFFF)
	end
	LIP.save('moonloader\\config\\rtimer.ini', data)
end
function cmdChangeDrugsTxdType(param)
	local txdtype = tonumber(param)
	if txdtype == 0 then data.usedrugs.txdtype = 0 sampAddChatMessage('Выбран тип оверлея "Drugs" [0]', 0xFFFFF) end
	if txdtype == 1 then data.usedrugs.txdtype = 1 sampAddChatMessage('Выбран тип оверлея "Drugs 150" [1]', 0xFFFFF) end
	if txdtype == 2 then data.usedrugs.txdtype = 2 sampAddChatMessage('Выбран тип оверлея "150" [2]', 0xFFFFF) end
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
		sampShowDialog(3838, "Изменение координат TextDraw'a", "Изменить координаты можно с помощью стрелочек.\nЧтобы принять координаты, нажмите \"Enter\".\nЧтобы отменить, нажмите пробел.\nВ меню можно восстановить стандартные.", "Я понял")
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
		sampShowDialog(3838, "Изменение размера TextDraw'a", "Изменить размер можно с помощью стрелочек вверх-вниз.\nЧтобы принять размер, нажмите \"Enter\".\nЧтобы отменить, нажмите пробел.\nВ меню можно восстановить стандартный.", "Я понял")
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
	submenus_show(mod_submenus_sa, '{348cb2}RTIMER v'..thisScript().version..'', 'Выбрать', 'Закрыть', 'Назад')
end
function scriptmenu()
	menutrigger = 1
end
-- функция включает/выключает уведомление
function cmdScriptInform()
	if data.options.startmessage == 1 then
		data.options.startmessage = 0 sampAddChatMessage(('Уведомление активации RTIMER при запуске игры отключено'), 0x348cb2)
	else
		data.options.startmessage = 1 sampAddChatMessage(('Уведомление активации RTIMER при запуске игры включено'), 0x348cb2)
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
--Функция LIP.load() отвечает за загрузку .ini
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
--Функция LIP.save() отвечает за сохранение .ini
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
					sampAddChatMessage(('[RTIMER]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь..'), 0x8B0000)
					sampAddChatMessage(('[RTIMER]: Текущая версия: '..thisScript().version..". Новая версия: "..version), 0x8B0000)
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
	sampAddChatMessage(('[RTIMER]: Обновление завершено! Подробнее об обновлении - /glonasslog.'), 0x8B0000)
	goplay = 1
	thisScript():reload()
end
end)
end
