require 'lib.moonloader'
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("rtimer")
script_version("05.07.2019-1")
script_author("qrlk")
script_description("/rtimer")
script_url("https://github.com/qrlk/rtimer")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://980fa6938189457d854dd10234626e21@o1272228.ingest.sentry.io/6530005" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/rtimer/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/rtimer"
    end
  end
end
--------------------------------------VAR---------------------------------------
color = 0x348cb2
local inicfg = require 'inicfg'
local prefix = '['..string.upper(thisScript().name)..']: '
local dlstatus = require('moonloader').download_status
local settings = inicfg.load({
  options =
  {
    startmessage = 1,
    autoupdate = 1,
  },
  ugon =
  {
    isactive = 1,
    count = 0,
    cooldown = 900,
    sound = 1,
    allcount = 0,
    money = 0,
    istxdactive = 1,
    posX1 = 588,
    posY1 = 428,
    size1 = 0.5,
    size2 = 2,
    style1 = 3,
  },
  usedrugs =
  {
    isactive = 1,
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
    --[KEY]
    key = 88,
  },
  zadrottimer =
  {
    date = 0,
    time = 0,
    limit = 0,
    posX1 = 591,
    posY1 = 418,
    size1 = 0.5,
    size2 = 1.3,
    style1 = 3,
    text = "Limit"
  },
}, 'rtimer\\settings.ini')
--------------------------------------------------------------------------------
-------------------------------BOOT РАЗДЕЛ СКРИПТА------------------------------
--------------------------------------------------------------------------------
function main()
  font = renderCreateFont("Arial", 16, 5) -- для изменения размера и шрифта рендера дальнобоя
  while not isSampAvailable() do wait(10) end
	if settings.options.autoupdate == 1 then
    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
      pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
	end

  firstload()
  onload()
  while sampGetCurrentServerName() == "SA-MP" do
    wait(10)
  end
  if string.find(sampGetCurrentServerName(), 'Samp%-Rp.Ru') then
    ugon = lua_thread.create(ugon)
    usedrugs = lua_thread.create(usedrugs)
  end
  zadrottimer = lua_thread.create(zadrottimer)
  while true do
    wait(0)
    if menutrigger ~= nil then menu() menutrigger = nil end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------ТАЙМЕР ЗАДРОТСТВА-------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function zadrottimer()
  savehelper = 1
  local time = settings.zadrottimer.time
  if time > 3600 then
    activehour = math.floor(time / 3600)
    time = time % 3600
    activeminute = math.floor(time / 60)
    activesec = time % 60
  else
    activehour = 0
    activeminute = math.floor(time / 60)
    activesec = time % 60
  end
  while true do
    wait(0)
    if os.date("%x") ~= settings.zadrottimer.date and tonumber(os.date("%H")) > 4 then
      settings.zadrottimer.date = os.date("%x")
      settings.zadrottimer.time = 0
      saveini(1);
    end
    if settings.zadrottimer.limit - settings.zadrottimer.time < 0 and settings.zadrottimer.limit ~= 0 then
      sampTextdrawCreate(423, settings.zadrottimer.text, settings.zadrottimer.posX1, settings.zadrottimer.posY1)
      sampTextdrawSetStyle(423, settings.zadrottimer.style1)
      sampTextdrawSetLetterSizeAndColor(423, settings.zadrottimer.size1, settings.zadrottimer.size2, - 65536 )
      sampTextdrawSetOutlineColor(423, 1, - 16777216)
    elseif sampTextdrawIsExists(423) then
      sampTextdrawDelete(423)
    end
    if isPlayerPlaying(PLAYER_PED) == true then
      wait(1000)
      settings.zadrottimer.time = settings.zadrottimer.time + 1
      savehelper = savehelper + 1
      local time = settings.zadrottimer.time
      if time > 3600 then
        activehour = math.floor(time / 3600)
        time = time % 3600
        activeminute = math.floor(time / 60)
        activesec = time % 60
      else
        activehour = 0
        activeminute = math.floor(time / 60)
        activesec = time % 60
      end
    end
    if savehelper > math.random(25, 60) then
      savehelper = 1
      saveini(1);
    end
  end
end
function rtime(limit)
  if limit == 228966 then
    local limiter = settings.zadrottimer.limit
    if limiter > 3600 then
      activehourlimiter = math.floor(limiter / 3600)
      limiter = limiter % 3600
      activeminutelimiter = math.floor(limiter / 60)
      activeseclimiter = limiter % 60
    elseif limiter > 0 then
      activehourlimiter = 0
      activeminutelimiter = math.floor(limiter / 60)
      activeseclimiter = limiter % 60
    end

    sampShowDialog(987, "Изменение лимита", string.format("Текущий лимит: "..tostring(activehourlimiter).." ч. "..tostring(activeminutelimiter).." м. "..tostring(activeseclimiter).." с.\nЕсли вы хотите удалить лимит, введите '0'\nЕсли вы хотите установить новый лимит, введите время в формате 'ЧЧ:ММ'"), "Выбрать", "Закрыть", 1)
    while sampIsDialogActive(987) do wait(100) end
    local resultMain, buttonMain, typ = sampHasDialogRespond(987)
    if buttonMain == 1 then
      rtime(sampGetCurrentDialogEditboxText(987))
    end
  else
    local temph, tempm = string.match(limit, "(%d+):(%d+)")
    limit = tonumber(limit)
    if temph ~= nil and tempm ~= nil and tonumber(tempm) < 60 then
      settings.zadrottimer.limit = temph * 3600 + tempm * 60
      sampAddChatMessage("Установлен новый лимит: "..settings.zadrottimer.limit.." секунд.", color)
      saveini(1)
    elseif limit == 0 then settings.zadrottimer.limit = 0
      sampAddChatMessage("Установлен новый лимит: 0 секунд.", color)
      saveini(1)
    elseif limit ~= 0 then
      limited = settings.zadrottimer.limit - settings.zadrottimer.time
      if limited > 3600 then
        activehourlimit = math.floor(limited / 3600)
        limited = limited % 3600
        activeminutelimit = math.floor(limited / 60)
        activeseclimit = limited % 60
      elseif limited > 0 then
        activehourlimit = 0
        activeminutelimit = math.floor(limited / 60)
        activeseclimit = limited % 60
      elseif limited < 0 then
        limited = limited * - 1
        if limited > 3600 then
          activehourlimit = math.floor(limited / 3600)
          limited = limited % 3600
          activeminutelimit = math.floor(limited / 60)
          activeseclimit = limited % 60
        elseif limited > 0 then
          activehourlimit = 0
          activeminutelimit = math.floor(limited / 60)
          activeseclimit = limited % 60
        end
        limited = limited * - 1
      end
      if limited > 0 then
        local limiter = settings.zadrottimer.limit
        if limiter > 3600 then
          activehourlimiter = math.floor(limiter / 3600)
          limiter = limiter % 3600
          activeminutelimiter = math.floor(limiter / 60)
          activeseclimiter = limiter % 60
        elseif limiter > 0 then
          activehourlimiter = 0
          activeminutelimiter = math.floor(limiter / 60)
          activeseclimiter = limiter % 60
        end
        sampShowDialog(2343, "{348cb2}RTIMER: Таймер задротства.", "{ffcc00}За сегодня: "..activehour.." ч. "..activeminute.." м. " ..activesec.." с.\nОсталось: "..activehourlimit.." ч. "..activeminutelimit.." м. "..activeseclimit.." с.\n\nУстановленный лимит: "..settings.zadrottimer.limit.." с.\nЭто "..activehourlimiter.." ч. "..activeminutelimiter.." м. "..activeseclimiter.." с.", "Закрыть")
      elseif settings.zadrottimer.limit == 0 then
        sampShowDialog(2343, "{348cb2}RTIMER: Таймер задротства.", "{ffcc00}За сегодня: "..activehour.." ч. "..activeminute.." м. " ..activesec.." с.\nЛимит не установлен.", "Закрыть")
      elseif settings.zadrottimer.limit ~= 0 then
        sampShowDialog(2343, "{348cb2}RTIMER: Таймер задротства.", "{ffcc00}За сегодня: "..activehour.." ч. "..activeminute.." м. " ..activesec.." с.\n{ff0000}Лимит превышен на: "..activehourlimit.." ч. "..activeminutelimit.." м. "..activeseclimit.." с.", "Закрыть")
        addOneOffSound(0.0, 0.0, 0.0, 1139)
      end
    end
  end
end
--------------------------------------------------------------------------------
-------------------------------НАСТРОЙКИ ЗАДРОТТАЙМА----------------------------
--------------------------------------------------------------------------------
function cmdChangeZadrotTimerPos(param)
  local ugonpostype = tonumber(param)
  if ugonpostype == 0 then
    local bckpX1 = settings.zadrottimer.posX1
    local bckpY1 = settings.zadrottimer.posY1
    local bckpS1 = settings.zadrottimer.size1
    local bckpS2 = settings.zadrottimer.size2
    sampShowDialog(3838, "Изменение положения и размера.", "{ffcc00}Изменение положения textdraw.\n{ffffff}Изменить положение можно с помощью стрелок клавы.\n\n{ffcc00}Изменение размера textdraw.\n{ffffff}Изменить размер ПРОПОРЦИОНАЛЬНО можно с помощью {00ccff}'-'{ffffff} и {00ccff}'+'{ffffff}.\n{ffffff}Изменить размер по горизонтали можно с помощью {00ccff}'9'{ffffff} и {00ccff}'0'{ffffff}.\n{ffffff}Изменить размер по вертикали можно с помощью {00ccff}'7'{ffffff} и {00ccff}'8'{ffffff}.\n\n{ffcc00}Как принять изменения?\n{ffffff}Нажмите \"Enter\", чтобы принять изменения.\nНажмите пробел, чтобы отменить изменения.\nВ меню можно восстановить дефолт.", "Я понял")
    while sampIsDialogActive(3838) == true do wait(100) end
    while true do
      wait(0)
      if bckpY1 > 0 and bckpY1 < 480 and bckpX1 > 0 and bckpX1 < 640 then
        wait(0)
        sampTextdrawCreate(424, settings.zadrottimer.text, bckpX1, bckpY1)
        sampTextdrawSetStyle(424, settings.zadrottimer.style1)
        sampTextdrawSetLetterSizeAndColor(424, bckpS1, bckpS2, - 65536)
        sampTextdrawSetOutlineColor(424, 1, - 16777216)
        if isKeyDown(40) and bckpY1 + 1 < 480 then bckpY1 = bckpY1 + 1 end
        if isKeyDown(38) and bckpY1 - 1 > 0 then bckpY1 = bckpY1 - 1 end
        if isKeyDown(37) and bckpX1 - 1 > 0 then bckpX1 = bckpX1 - 1 end
        if isKeyDown(39) and bckpX1 + 1 < 640 then bckpX1 = bckpX1 + 1 end
        if isKeyJustPressed(57) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
          end
        end
        if isKeyJustPressed(48) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
          end
        end

        if isKeyJustPressed(55) then
          if bckpS2 - 0.1 > 0 then
            bckpS2 = bckpS2 - 0.1
          end
        end
        if isKeyJustPressed(56) then
          if bckpS2 + 0.1 > 0 then
            bckpS2 = bckpS2 + 0.1
          end
        end
        if isKeyJustPressed(189) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
            bckpS2 = bckpS1 * 2.6
          end
        end
        if isKeyJustPressed(187) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
            bckpS2 = bckpS1 * 2.6
          end
        end

        if isKeyJustPressed(13) then
          settings.zadrottimer.posX1 = bckpX1
          settings.zadrottimer.posY1 = bckpY1
          settings.zadrottimer.size1 = bckpS1
          settings.zadrottimer.size2 = bckpS2
          sampTextdrawDelete(424)
          addOneOffSound(0.0, 0.0, 0.0, 1052)
          saveini(1)
          zadrottimer:terminate()
          zadrottimer:run()
          break
        end
        if isKeyJustPressed(32) then
          addOneOffSound(0.0, 0.0, 0.0, 1053)
          sampTextdrawDelete(424)
          zadrottimer:terminate()
          zadrottimer:run()
          break
        end
      end
    end
  end
  if ugonpostype == 1 then
    settings.zadrottimer.posX1 = 591
    settings.zadrottimer.posY1 = 418
    settings.zadrottimer.size1 = 0.5
    settings.zadrottimer.size2 = 1.3
    addOneOffSound(0.0, 0.0, 0.0, 1052)
    saveini(1)
    ugon:terminate()
    ugon:run()
  end
end
function cmdZadrotTimerDefault()
  settings.zadrottimer.style1 = 3
  settings.zadrottimer.posX1 = 591
  settings.zadrottimer.posY1 = 418
  settings.zadrottimer.size1 = 0.5
  settings.zadrottimer.size2 = 1.3
  settings.zadrottimer.text = "Limit"
  saveini(1)
  zadrottimer:terminate()
  zadrottimer:run()
end
function cmdChangeZadrotTimerTxdStyle(param)
  local txdstyle = tonumber(param)
  settings.zadrottimer.style1 = txdstyle
  addOneOffSound(0.0, 0.0, 0.0, 1052)
  saveini(1)
  zadrottimer:terminate()
  zadrottimer:run()
end
function cmdZadrotTimerText()
  sampShowDialog(988, "Изменение text'a лимита", string.format("Введите текст лимита"), "Выбрать", "Закрыть", 1)
  while sampIsDialogActive(988) do wait(100) end
  local resultMain, buttonMain, typ = sampHasDialogRespond(988)
  if buttonMain == 1 then
    settings.zadrottimer.text = sampGetCurrentDialogEditboxText(988)
    saveini(1)
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------ТАЙМЕР НАРКОТИКОВ-------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function usedrugs()
  if settings.usedrugs.isactive == 1 then
    if settings.usedrugs.txdtype == 0 then
      sampTextdrawCreate(420, "Drugs", settings.usedrugs.posX1, settings.usedrugs.posY1)
    end
    if settings.usedrugs.txdtype == 1 then
      sampTextdrawCreate(420, "Drugs "..intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
    end
    if settings.usedrugs.txdtype == 2 then
      sampTextdrawCreate(420, intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
    end
    lua_thread.create(usedrugskolvo)
    ust = lua_thread.create(usedrugstimer)
    sampTextdrawSetStyle(420, settings.usedrugs.style1)
    sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
    sampTextdrawSetOutlineColor(420, 1, - 16777216)
    narkotrigger = true
    while true do
      wait(0)
      if isKeyJustPressed(settings.usedrugs.key) and sampIsDialogActive() == false and sampIsChatInputActive() == false and isPauseMenuActive() == false then
        if narkotrigger == true then
          if stopscan == nil then stopscan = 0 end
          kolvousedrugs = math.ceil((160 - getCharHealth(playerPed)) / 10)
          if kolvousedrugs == 0 then kolvousedrugs = 1 end
          if intim.usedrugs.kolvo ~= "???" and kolvousedrugs > tonumber(intim.usedrugs.kolvo) and tonumber(intim.usedrugs.kolvo) > 0 then kolvousedrugs = tonumber(intim.usedrugs.kolvo) end
          if kolvousedrugs == 16 then kolvousedrugs = 15 end
          if narkotrigger == true then sampSendChat("/usedrugs "..kolvousedrugs) narkotrigger = false end
          chat99 = "1"
          while chat99 ~= " Недостаточно наркотиков" and chat99 ~= " Не флуди!" do
            stopscan = stopscan + 1
            chat99, prefix, color1, pcolor = sampGetChatString(99)
            wait(20)
            if string.find(chat99, 'Остаток') then
              intim.usedrugs.lasttime = os.time()
              narkotrigger = false
              stopscan = nil
              saveini(2)
              chat99 = nil
              break
            end
            if stopscan > 100 then stopscan = nil narkotrigger = true break end
          end
        elseif isKeyDown(settings.usedrugs.key) then
          wait(1000)
          if isKeyDown(settings.usedrugs.key) then
            sampSendChat("/usedrugs 1")
          end
        end
      end
    end
  end
end
function usedrugstimer()
  while true do
    wait(0)
    if narkotrigger == false then sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 ) end
    while narkotrigger == false do
      wait(0)
      sampTextdrawCreate(421, intim.usedrugs.lasttime + settings.usedrugs.cooldown - os.time(), settings.usedrugs.posX2, settings.usedrugs.posY2)
      sampTextdrawSetStyle(421, settings.usedrugs.style2)
      sampTextdrawSetLetterSizeAndColor(421, settings.usedrugs.size3, settings.usedrugs.size4, - 13447886)
      sampTextdrawSetOutlineColor(421, 1, - 16777216)
      if intim.usedrugs.lasttime + settings.usedrugs.cooldown <= os.time() then
        sampTextdrawDelete(421)
        if settings.usedrugs.sound == 1 and isKeyDown(settings.usedrugs.key) == false then addOneOffSound(0.0, 0.0, 0.0, 1057) end
        sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
        narkotrigger = true
      end
    end
  end
end
function usedrugskolvo()
  while true do
    wait(0)
    chat99, prefix, color1347, pcolor = sampGetChatString(99)
    --покупка в притоне
    if string.find(chat99, "(У вас есть (%d+) грамм)") then
      if string.match(chat99, "(%d+)", string.find(chat99, "(У вас есть (%d+) грамм)")) ~= nil and string.match(chat99, "(%d+)", string.find(chat99, "(У вас есть (%d+) грамм)")) ~= intim.usedrugs.kolvo then
        intim.usedrugs.kolvo = string.match(chat99, "(%d+)", string.find(chat99, "(У вас есть (%d+) грамм)"))
        saveini(2)
        if settings.usedrugs.txdtype == 1 then
          sampTextdrawCreate(420, "Drugs "..intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
          sampTextdrawSetStyle(420, settings.usedrugs.style1)
          if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
          else
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
          end
          sampTextdrawSetOutlineColor(420, 1, - 16777216)
        end
        if settings.usedrugs.txdtype == 2 then
          sampTextdrawCreate(420, intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
          sampTextdrawSetStyle(420, settings.usedrugs.style1)
          if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
          else
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
          end
          sampTextdrawSetOutlineColor(420, 1, - 16777216)
        end
        chat99 = nil
      end
    end
    if chat99 == " Вы взяли из сейфа нарко" or chat99 == " Вы положили в сейф нарко" then
      intim.usedrugs.kolvo = "???"
      saveini(2)
      if settings.usedrugs.txdtype == 1 then
        sampTextdrawCreate(420, "Drugs "..intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
        sampTextdrawSetStyle(420, settings.usedrugs.style1)
        if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
          sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
        else
          sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
        end
        sampTextdrawSetOutlineColor(420, 1, - 16777216)
      end
      if settings.usedrugs.txdtype == 2 then
        sampTextdrawCreate(420, intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
        sampTextdrawSetStyle(420, settings.usedrugs.style1)
        if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
          sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
        else
          sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
        end
        sampTextdrawSetOutlineColor(420, 1, - 16777216)
      end
      chat99 = nil
    end
    --покупка с рук, кража, продажа на руки.
    chat98, prefix, color1345, pcolor = sampGetChatString(98)
    chat99, prefix, color1345, pcolor = sampGetChatString(99)
    if not string.find(chat98, " Вы купили ", 1, true) and not string.find(chat98, " грамм за ", 1, true) then trigger1 = true end
    if not string.find(chat98, " купил(а) у вас ", 1, true) and not string.find(chat98, " грамм ", 1, true) then trigger2 = true end
    if ((string.find(chat99, "(( Остаток:", 1, true)) and not string.find(chat99, "материалов", 1, true)) or chat99 == " Вы украли 150 грамм наркотических лекарств" or (string.find(chat98, " Вы купили ", 1, true) and not string.find(chat98, "У вас есть", 1, true) and string.find(chat98, " грамм за ", 1, true) and trigger1 == true) or (string.find(chat98, " купил(а) у вас ", 1, true) and string.find(chat98, " грамм ", 1, true) and trigger2 == true) then
      if string.match(chat98, "(%d+)") ~= nil or string.match(chat99, "(%d+)") then
        if string.find(chat98, " Вы купили ", 1, true) then intim.usedrugs.kolvo = intim.usedrugs.kolvo + string.match(chat98, "(%d+)") trigger1 = false
        elseif string.match(chat99, "(%d+)") ~= intim.usedrugs.kolvo and not string.find(chat98, " купил(а) у вас ", 1, true) then intim.usedrugs.kolvo = string.match(chat99, "(%d+)") end
        if string.find(chat98, " купил(а) у вас ", 1, true) and string.find(chat98, " грамм ", 1, true) then intim.usedrugs.kolvo = intim.usedrugs.kolvo - string.match(chat98, "(%d+)") trigger2 = false end
        saveini(2)
        if settings.usedrugs.txdtype == 1 then
          sampTextdrawCreate(420, "Drugs "..intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
          sampTextdrawSetStyle(420, settings.usedrugs.style1)
          if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
          else
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
          end
          sampTextdrawSetOutlineColor(420, 1, - 16777216)
        end
        if settings.usedrugs.txdtype == 2 then
          sampTextdrawCreate(420, intim.usedrugs.kolvo, settings.usedrugs.posX1, settings.usedrugs.posY1)
          sampTextdrawSetStyle(420, settings.usedrugs.style1)
          if os.time() < intim.usedrugs.lasttime + settings.usedrugs.cooldown then
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 )
          else
            sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 13447886)
          end
          sampTextdrawSetOutlineColor(420, 1, - 16777216)
        end
        chat98 = nil
      end
    end
  end
end
--------------------------------------------------------------------------------
-------------------------------НАСТРОЙКИ НАРКОТИКОВ-----------------------------
--------------------------------------------------------------------------------
function cmdChangeDrugsHotkey()
  sampShowDialog(989, "Изменение горячей клавиши", "Нажмите \"Окей\", после чего нажмите нужную клавишу.\nНастройки будут изменены.", "Окей", "Закрыть")
  while sampIsDialogActive(989) do wait(100) end
  local resultMain, buttonMain, typ = sampHasDialogRespond(988)
  if buttonMain == 1 then
    while ke1y == nil do
      wait(0)
      for i = 1, 200 do
        if isKeyDown(i) then
          settings.usedrugs.key = i
          sampAddChatMessage("Установлена новая горячая клавиша - "..settings.usedrugs.key, color)
          saveini(1) ke1y = 1 break
        end
      end
    end
  end
  ke1y = nil
end
function cmdDrugsTxdDefault()
  settings.usedrugs.style1 = 3
  settings.usedrugs.posX1 = 56
  settings.usedrugs.posY1 = 424
  settings.usedrugs.size1 = 0.6
  settings.usedrugs.size2 = 1.2
  saveini(1)
  usedrugs:terminate()
  if narkotrigger == false then
    usedrugs:run()
    wait(100)
    narkotrigger = false
  else
    usedrugs:run()
  end
end
function cmdDrugsTimerDefault()
  settings.usedrugs.style2 = 3
  settings.usedrugs.posX2 = 80
  settings.usedrugs.posY2 = 315
  settings.usedrugs.size3 = 0.4
  settings.usedrugs.size4 = 2
  saveini(1)
  usedrugs:terminate()
  if narkotrigger == false then
    usedrugs:run()
    wait(100)
    narkotrigger = false
  else
    usedrugs:run()
  end
end
function cleardrugstxds()
  sampTextdrawDelete(420)
  sampTextdrawDelete(421)
end
function cmdChangeUsedrugsDelay()
  sampShowDialog(989, "Установка задержки нарко", string.format("Введите задержку в секундах.\nТекущая задержка: "..settings.usedrugs.cooldown.." сек."), "Выбрать", "Закрыть", 1)
  while sampIsDialogActive() do wait(100) end
  if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
    settings.usedrugs.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
    saveini(1)
  end
end
function cmdChangeUsedrugsActive()
  if settings.usedrugs.isactive == 1 then settings.usedrugs.isactive = 0 sampAddChatMessage('[RTIMER]: Таймер нарко деактивирован.', color) cleardrugstxds()
    usedrugs:terminate()


  else settings.usedrugs.isactive = 1 sampAddChatMessage('[RTIMER]: Таймер нарко активирован.', color)
    if narkotrigger == false then
      usedrugs:run()
      wait(100)
      narkotrigger = false
    else
      usedrugs:run()
    end
  end
  saveini(1)
end
function cmdChangeUsedrugsSoundActive()
  if settings.usedrugs.sound == 1 then settings.usedrugs.sound = 0 sampAddChatMessage('[RTIMER]: "ПДИНЬ" при истечении кд нарко выключен.', color) else settings.usedrugs.sound = 1 sampAddChatMessage('[RTIMER]: "ПДИНЬ" при истечении кд нарко включен.', color)
  end
  saveini(1)
end
function cmdChangeDrugsTxdType(param)
  local txdtype = tonumber(param)
  if txdtype == 0 then settings.usedrugs.txdtype = 0 end
  if txdtype == 1 then settings.usedrugs.txdtype = 1 end
  if txdtype == 2 then settings.usedrugs.txdtype = 2 end
  saveini(1)
  usedrugs:terminate()
  if narkotrigger == false then
    usedrugs:run()
    wait(100)
    narkotrigger = false
  else
    usedrugs:run()
  end
end
function cmdChangeDrugsPos(param)
  local drugspostype = tonumber(param)
  if drugspostype == 0 then
    local bckpX1 = settings.usedrugs.posX1
    local bckpY1 = settings.usedrugs.posY1
    local bckpS1 = settings.usedrugs.size1
    local bckpS2 = settings.usedrugs.size2
    sampShowDialog(3838, "Изменение положения и размера.", "{ffcc00}Изменение положения textdraw.\n{ffffff}Изменить положение можно с помощью стрелок клавы.\n\n{ffcc00}Изменение размера textdraw.\n{ffffff}Изменить размер ПРОПОРЦИОНАЛЬНО можно с помощью {00ccff}'-'{ffffff} и {00ccff}'+'{ffffff}.\n{ffffff}Изменить размер по горизонтали можно с помощью {00ccff}'9'{ffffff} и {00ccff}'0'{ffffff}.\n{ffffff}Изменить размер по вертикали можно с помощью {00ccff}'7'{ffffff} и {00ccff}'8'{ffffff}.\n\n{ffcc00}Как принять изменения?\n{ffffff}Нажмите \"Enter\", чтобы принять изменения.\nНажмите пробел, чтобы отменить изменения.\nВ меню можно восстановить дефолт.", "Я понял")
    while sampIsDialogActive(3838) == true do wait(100) end
    while true do
      wait(0)
      if bckpY1 > 0 and bckpY1 < 480 and bckpX1 > 0 and bckpX1 < 640 then
        wait(0)
        if isKeyDown(40) and bckpY1 + 1 < 480 then bckpY1 = bckpY1 + 1 end
        if isKeyDown(38) and bckpY1 - 1 > 0 then bckpY1 = bckpY1 - 1 end
        if isKeyDown(37) and bckpX1 - 1 > 0 then bckpX1 = bckpX1 - 1 end
        if isKeyDown(39) and bckpX1 + 1 < 640 then bckpX1 = bckpX1 + 1 end
        if isKeyJustPressed(57) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
          end
        end
        if isKeyJustPressed(48) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
          end
        end

        if isKeyJustPressed(55) then
          if bckpS2 - 0.1 > 0 then
            bckpS2 = bckpS2 - 0.1
          end
        end
        if isKeyJustPressed(56) then
          if bckpS2 + 0.1 > 0 then
            bckpS2 = bckpS2 + 0.1
          end
        end
        if isKeyJustPressed(189) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
            bckpS2 = bckpS1 * 2
          end
        end
        if isKeyJustPressed(187) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
            bckpS2 = bckpS1 * 2
          end
        end
        if settings.usedrugs.isactive == 1 then
          if settings.usedrugs.txdtype == 0 then
            sampTextdrawCreate(420, "Drugs", bckpX1, bckpY1)
          end
          if settings.usedrugs.txdtype == 1 then
            sampTextdrawCreate(420, "Drugs "..intim.usedrugs.kolvo, bckpX1, bckpY1)
          end
          if settings.usedrugs.txdtype == 2 then
            sampTextdrawCreate(420, intim.usedrugs.kolvo, bckpX1, bckpY1)
          end
          sampTextdrawSetStyle(420, settings.usedrugs.style1)
          sampTextdrawSetLetterSizeAndColor(420, bckpS1, bckpS2, - 13447886)
          sampTextdrawSetOutlineColor(420, 1, - 16777216)
        end
        if isKeyJustPressed(13) then
          settings.usedrugs.posX1 = bckpX1
          settings.usedrugs.posY1 = bckpY1
          settings.usedrugs.size1 = bckpS1
          settings.usedrugs.size2 = bckpS2
          addOneOffSound(0.0, 0.0, 0.0, 1052)
          saveini(1)
          usedrugs:terminate()



          if narkotrigger == false then
            usedrugs:run()
            wait(100)
            narkotrigger = false
          else
            usedrugs:run()
          end
          break
        end
        if isKeyJustPressed(32) then
          addOneOffSound(0.0, 0.0, 0.0, 1053)
          usedrugs:terminate()

          if narkotrigger == false then
            usedrugs:run()
            wait(100)
            narkotrigger = false
          else
            usedrugs:run()
          end
          break
        end
      end
    end
  end
  if drugspostype == 1 then
    settings.usedrugs.posX1 = 56
    settings.usedrugs.posY1 = 424
    settings.usedrugs.size1 = 0.6
    settings.usedrugs.size2 = 1.2
    addOneOffSound(0.0, 0.0, 0.0, 1052)
    saveini(1)
    usedrugs:terminate()

    if narkotrigger == false then
      usedrugs:run()
      wait(100)
      narkotrigger = false
    else
      usedrugs:run()
    end
  end
end
function cmdChangeDrugsTimerPos(param)
  local drugspostype = tonumber(param)
  if drugspostype == 0 then
    local bckpX1 = settings.usedrugs.posX2
    local bckpY1 = settings.usedrugs.posY2
    local bckpS1 = settings.usedrugs.size3
    local bckpS2 = settings.usedrugs.size4
    sampShowDialog(3838, "Изменение положения и размера.", "{ffcc00}Изменение положения textdraw.\n{ffffff}Изменить положение можно с помощью стрелок клавы.\n\n{ffcc00}Изменение размера textdraw.\n{ffffff}Изменить размер ПРОПОРЦИОНАЛЬНО можно с помощью {00ccff}'-'{ffffff} и {00ccff}'+'{ffffff}.\n{ffffff}Изменить размер по горизонтали можно с помощью {00ccff}'9'{ffffff} и {00ccff}'0'{ffffff}.\n{ffffff}Изменить размер по вертикали можно с помощью {00ccff}'7'{ffffff} и {00ccff}'8'{ffffff}.\n\n{ffcc00}Как принять изменения?\n{ffffff}Нажмите \"Enter\", чтобы принять изменения.\nНажмите пробел, чтобы отменить изменения.\nВ меню можно восстановить дефолт.", "Я понял")
    while sampIsDialogActive(3838) == true do wait(100) end
    while true do
      wait(0)
      if bckpY1 > 0 and bckpY1 < 480 and bckpX1 > 0 and bckpX1 < 640 then
        wait(0)
        if isKeyDown(40) and bckpY1 + 1 < 480 then bckpY1 = bckpY1 + 1 end
        if isKeyDown(38) and bckpY1 - 1 > 0 then bckpY1 = bckpY1 - 1 end
        if isKeyDown(37) and bckpX1 - 1 > 0 then bckpX1 = bckpX1 - 1 end
        if isKeyDown(39) and bckpX1 + 1 < 640 then bckpX1 = bckpX1 + 1 end
        if isKeyJustPressed(57) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
          end
        end
        if isKeyJustPressed(48) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
          end
        end
        if isKeyJustPressed(55) then
          if bckpS2 - 0.1 > 0 then
            bckpS2 = bckpS2 - 0.1
          end
        end
        if isKeyJustPressed(56) then
          if bckpS2 + 0.1 > 0 then
            bckpS2 = bckpS2 + 0.1
          end
        end
        if isKeyJustPressed(57) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
          end
        end
        if isKeyJustPressed(48) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
          end
        end
        if isKeyJustPressed(55) then
          if bckpS2 - 0.1 > 0 then
            bckpS2 = bckpS2 - 0.1
          end
        end
        if isKeyJustPressed(56) then
          if bckpS2 + 0.1 > 0 then
            bckpS2 = bckpS2 + 0.1
          end
        end
        if isKeyJustPressed(189) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
            bckpS2 = bckpS1 * 5
          end
        end
        if isKeyJustPressed(187) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
            bckpS2 = bckpS1 * 5
          end
        end
        if settings.usedrugs.isactive == 1 then
          sampTextdrawCreate(422, "69", bckpX1, bckpY1)
          sampTextdrawSetStyle(422, settings.usedrugs.style2)
          sampTextdrawSetLetterSizeAndColor(422, bckpS1, bckpS2, - 13447886)
          sampTextdrawSetOutlineColor(422, 1, - 16777216)
        end
        if isKeyJustPressed(13) then
          sampTextdrawDelete(422)
          if narkotrigger == false then sampTextdrawSetLetterSizeAndColor(420, settings.usedrugs.size1, settings.usedrugs.size2, - 65536 ) end
          settings.usedrugs.posX2 = bckpX1
          settings.usedrugs.posY2 = bckpY1
          settings.usedrugs.size3 = bckpS1
          settings.usedrugs.size4 = bckpS2
          addOneOffSound(0.0, 0.0, 0.0, 1052)
          saveini(1)
          usedrugs:terminate()
          if narkotrigger == false then
            usedrugs:run()
            wait(100)
            narkotrigger = false
          else
            usedrugs:run()
          end
          break
        end
        if isKeyJustPressed(32) then
          sampTextdrawDelete(422)
          addOneOffSound(0.0, 0.0, 0.0, 1053)
          usedrugs:terminate()
          if narkotrigger == false then
            usedrugs:run()
            wait(100)
            narkotrigger = false
          else
            usedrugs:run()
          end
          break
        end
      end
    end
  end
  if drugspostype == 1 then
    sampTextdrawDelete(421)
    settings.usedrugs.posX2 = 80
    settings.usedrugs.posY2 = 315
    settings.usedrugs.size3 = 0.4
    settings.usedrugs.size4 = 2
    addOneOffSound(0.0, 0.0, 0.0, 1052)
    saveini(1)
    usedrugs:terminate()

    if narkotrigger == false then
      usedrugs:run()
      wait(100)
      narkotrigger = false
    else
      usedrugs:run()
    end
  end
end
function cmdChangeDrugsTxdStyle(param)
  local txdstyle = tonumber(param)
  settings.usedrugs.style1 = txdstyle
  addOneOffSound(0.0, 0.0, 0.0, 1052)
  saveini(1)
  usedrugs:terminate()
  if narkotrigger == false then
    usedrugs:run()
    wait(100)
    narkotrigger = false
  else
    usedrugs:run()
  end
end
function cmdChangeDrugsTimerTxdStyle(param)
  local txdstyle = tonumber(param)
  settings.usedrugs.style2 = txdstyle
  addOneOffSound(0.0, 0.0, 0.0, 1052)
  saveini(1)
  usedrugs:terminate()
  if narkotrigger == false then
    usedrugs:run()
    wait(100)
    narkotrigger = false
  else
    usedrugs:run()
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------ТАЙМЕР АВТОУГОНА--------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ugonscanner()
  while true do
    wait(0)
    while intim.ugon.notif == 1 do
      chatscanner99, prefix, colorscanner97, pcolor = sampGetChatString(99)
      for i = 90, 99 do
        wait(10)
        chatscanner, prefix, colorscanner, pcolor = sampGetChatString(i)
      end
    end
  end
end
function getmoney()
  while true do
    wait(0)
    while triggermoney == true do
      wait(0)
      money = getPlayerMoney()
      wait(10000)
    end
  end
end
function min20()
  while true do
    wait(0)
    while Enablemin20 do
      wait(1200000)
      if Enablemin20 == true then stopugon = nil end
      Enablemin20 = false
    end
  end
end
function test1()
  sampAddChatMessage(" Подобную тачку наши парни недавно видели. Я обозначил район на твоей карте.")
end
function ugon()
  lua_thread.create(ugonscanner)
  triggermoney = true
  lua_thread.create(getmoney)
  lua_thread.create(min20)
  while true do
    wait(0)
    if settings.ugon.isactive == 1 then
      if chatscanner99 == " Подобную тачку наши парни недавно видели. Я обозначил район на твоей карте." and stopugon == nil then
        settings.ugon.allcount = settings.ugon.allcount + 1
        stopugon = 1
        Enablemin20 = true
        sampAddChatMessage("[RTIMER]: Зафиксировано "..settings.ugon.allcount.."-е взятие угона! Удачных: "..settings.ugon.count.."/"..settings.ugon.allcount.."! Всего заработано: "..settings.ugon.money.." вирт!", color)
        inicfg.save(settings, "rtimer\\settings")
      end
      if chatscanner99 == " SMS: Ты меня огорчил!" then stopugon = nil end
      if chatscanner == " Отличная тачка. Будет нужна работа, приходи." and intim.ugon.notif == 1 then
        triggermoney = false
        intim.ugon.lasttime = os.time()
        settings.ugon.count = settings.ugon.count + 1
        intim.ugon.notif = 0
        stopugon = nil
        Enablemin20 = false
        wait(1000)
        settings.ugon.money = settings.ugon.money + getPlayerMoney() - money
        sampAddChatMessage("[RTIMER]: Зафиксирован "..settings.ugon.count.."-й удачный угон! Всего заработано: "..settings.ugon.money.." вирт!", color)
        inicfg.save(settings, "rtimer\\settings")
        inicfg.save(intim, 'rtimer\\'..serverip..'-'..playernick)
        triggermoney = true
      end
      if intim.ugon.notif == 0 then
        if intim.ugon.lasttime + settings.ugon.cooldown <= os.time() then
          sampAddChatMessage("[RTIMER]: Теперь вы можете взять машину на угон в "..settings.ugon.count + 1 .."-й раз!", color)
          if settings.ugon.sound == 1 then addOneOffSound(0.0, 0.0, 0.0, 1147) end
          stopugon = nil
          intim.ugon.notif = 1
          inicfg.save(settings, "rtimer\\settings")
          inicfg.save(intim, 'rtimer\\'..serverip..'-'..playernick)
          wait(1000)
        end
      end
      ugondown = intim.ugon.lasttime + settings.ugon.cooldown - os.time()
      if ugondown > 0 then
        ugonminute = math.floor(ugondown / 60)
        ugonsec = ugondown % 60
        if ugonminute < 10 then ugonminute = "0"..ugonminute end
        if ugonsec < 10 then ugonsec = "0"..ugonsec end
        if settings.ugon.istxdactive == 1 then
          sampTextdrawCreate(419, ugonminute..":"..ugonsec, settings.ugon.posX1, settings.ugon.posY1)
          sampTextdrawSetStyle(419, settings.ugon.style1)
          sampTextdrawSetLetterSizeAndColor(419, settings.ugon.size1, settings.ugon.size2, - 65536)
          sampTextdrawSetOutlineColor(419, 1, - 16777216)
        end
      else
        if settings.ugon.istxdactive == 1 then
          sampTextdrawCreate(419, "00:00", settings.ugon.posX1, settings.ugon.posY1)
          sampTextdrawSetStyle(419, settings.ugon.style1)
          sampTextdrawSetLetterSizeAndColor(419, settings.ugon.size1, settings.ugon.size2, - 13447886)
          sampTextdrawSetOutlineColor(419, 1, - 16777216)
        end
      end
    end
  end
end
function cmdGetUgonStats()
  sampShowDialog(2346, "{348cb2}Статистика угона", "{ffffff}Количество взятых угонов: {348cb2}"..settings.ugon.allcount.."\n{ffffff}Количество удачных угонов: {348cb2}"..settings.ugon.count.."\n{ffffff}Заработанных денег: {348cb2}"..settings.ugon.money.." вирт\n{ffffff}Ugonrate: {348cb2}"..math.floor(settings.ugon.count / settings.ugon.allcount * 100).."%", "Закрыть")
end
--------------------------------------------------------------------------------
-------------------------------НАСТРОЙКИ АВТОУГОНА------------------------------
--------------------------------------------------------------------------------
function cmdChangeUgonSoundActive()
  if settings.ugon.sound == 1 then settings.ugon.sound = 0 sampAddChatMessage('[RTIMER]: Гудок при истечении кд угона отключен.', color) else settings.ugon.sound = 1 sampAddChatMessage('[RTIMER]: Гудок при истечении кд угона включен.', color)
  end
  saveini(1)
end
function cmdChangeUgonTimerPos(param)
  local ugonpostype = tonumber(param)
  if ugonpostype == 0 then
    local bckpX1 = settings.ugon.posX1
    local bckpY1 = settings.ugon.posY1
    local bckpS1 = settings.ugon.size1
    local bckpS2 = settings.ugon.size2
    sampShowDialog(3838, "Изменение положения и размера.", "{ffcc00}Изменение положения textdraw.\n{ffffff}Изменить положение можно с помощью стрелок клавы.\n\n{ffcc00}Изменение размера textdraw.\n{ffffff}Изменить размер ПРОПОРЦИОНАЛЬНО можно с помощью {00ccff}'-'{ffffff} и {00ccff}'+'{ffffff}.\n{ffffff}Изменить размер по горизонтали можно с помощью {00ccff}'9'{ffffff} и {00ccff}'0'{ffffff}.\n{ffffff}Изменить размер по вертикали можно с помощью {00ccff}'7'{ffffff} и {00ccff}'8'{ffffff}.\n\n{ffcc00}Как принять изменения?\n{ffffff}Нажмите \"Enter\", чтобы принять изменения.\nНажмите пробел, чтобы отменить изменения.\nВ меню можно восстановить дефолт.", "Я понял")
    while sampIsDialogActive(3838) == true do wait(100) end
    while true do
      wait(0)
      if bckpY1 > 0 and bckpY1 < 480 and bckpX1 > 0 and bckpX1 < 640 then
        wait(0)
        sampTextdrawCreate(422, "00:00", bckpX1, bckpY1)
        sampTextdrawSetStyle(422, settings.ugon.style1)
        sampTextdrawSetLetterSizeAndColor(422, bckpS1, bckpS2, - 13447886)
        sampTextdrawSetOutlineColor(422, 1, - 16777216)
        if isKeyDown(40) and bckpY1 + 1 < 480 then bckpY1 = bckpY1 + 1 end
        if isKeyDown(38) and bckpY1 - 1 > 0 then bckpY1 = bckpY1 - 1 end
        if isKeyDown(37) and bckpX1 - 1 > 0 then bckpX1 = bckpX1 - 1 end
        if isKeyDown(39) and bckpX1 + 1 < 640 then bckpX1 = bckpX1 + 1 end
        if isKeyJustPressed(57) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
          end
        end
        if isKeyJustPressed(48) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
          end
        end
        if isKeyJustPressed(55) then
          if bckpS2 - 0.1 > 0 then
            bckpS2 = bckpS2 - 0.1
          end
        end
        if isKeyJustPressed(56) then
          if bckpS2 + 0.1 > 0 then
            bckpS2 = bckpS2 + 0.1
          end
        end
        if isKeyJustPressed(189) then
          if bckpS1 - 0.1 > 0 then
            bckpS1 = bckpS1 - 0.1
            bckpS2 = bckpS1 * 4
          end
        end
        if isKeyJustPressed(187) then
          if bckpS1 + 0.1 > 0 then
            bckpS1 = bckpS1 + 0.1
            bckpS2 = bckpS1 * 4
          end
        end
        if isKeyJustPressed(13) then
          settings.ugon.posX1 = bckpX1
          settings.ugon.posY1 = bckpY1
          settings.ugon.size1 = bckpS1
          settings.ugon.size2 = bckpS2
          sampTextdrawDelete(422)
          addOneOffSound(0.0, 0.0, 0.0, 1052)
          saveini(1)
          ugon:terminate()
          ugon:run()
          break
        end
        if isKeyJustPressed(32) then
          addOneOffSound(0.0, 0.0, 0.0, 1053)
          sampTextdrawDelete(422)
          ugon:terminate()
          ugon:run()
          break
        end
      end
    end
  end
  if ugonpostype == 1 then
    settings.ugon.posX1 = 588
    settings.ugon.posY1 = 428
    settings.ugon.size1 = 0.5
    settings.ugon.size2 = 2
    addOneOffSound(0.0, 0.0, 0.0, 1052)
    saveini(1)
    ugon:terminate()
    ugon:run()
  end
end
function cmdDrugsUgonDefault()
  settings.ugon.style1 = 3
  settings.ugon.posX1 = 588
  settings.ugon.posY1 = 428
  settings.ugon.size1 = 0.5
  settings.ugon.size2 = 2
  saveini(1)
  ugon:terminate()
  ugon:run()
end
function cmdChangeUgonTxdStyle(param)
  local txdstyle = tonumber(param)
  settings.ugon.style1 = txdstyle
  addOneOffSound(0.0, 0.0, 0.0, 1052)
  saveini(1)
  ugon:terminate()
  ugon:run()
end
function cmdChangeUgonDelay()
  sampShowDialog(989, "Установка задержки", string.format("Введите задержку в секундах.\nТекущая задержка: "..settings.ugon.cooldown.." сек."), "Выбрать", "Закрыть", 1)
  while sampIsDialogActive() do wait(100) end
  if tonumber(sampGetCurrentDialogEditboxText(989)) ~= nil then
    settings.ugon.cooldown = tonumber(sampGetCurrentDialogEditboxText(989))
    saveini(1)
  end
end
function cmdChangeUgonActive()
  if settings.ugon.isactive == 1 then settings.ugon.isactive = 0 sampAddChatMessage('[RTIMER]: Таймер угона деактивирован.', color) ugon:terminate() sampTextdrawDelete(422) sampTextdrawDelete(419) else settings.ugon.isactive = 1 sampAddChatMessage('[RTIMER]: Таймер угона активирован.', color) ugon:run()
  end
  saveini(1)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------------------------ПЕРВЫЙ ЗАПУСК---------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function firstload()
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\config\\rtimer") then createDirectory(getGameDirectory().."\\moonloader\\config\\rtimer") end
  if not doesFileExist(getGameDirectory().."\\moonloader\\config\\rtimer\\settings.ini") then
    if inicfg.save(settings, "rtimer\\settings") then
      sampAddChatMessage(('[RTIMER]: Первый запуск скрипта! Был создан .ini: moonloader\\config\\rtimer\\settings.ini'), color)
    end
  end
  serverip, serverport = sampGetCurrentServerAddress()
  asodkas, playerid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  playernick = sampGetPlayerNickname(playerid)
  intim = inicfg.load({
    ugon =
    {
      lasttime = 1,
      notif = 0,
    },
    usedrugs =
    {
      lasttime = 1,
      kolvo = "???",
    },
  }, 'rtimer\\'..serverip..'-'..playernick)
  if not doesFileExist(getGameDirectory().."\\moonloader\\config\\rtimer\\"..serverip.."-"..playernick..".ini") then
    if inicfg.save(intim, 'rtimer\\'..serverip..'-'..playernick) then
      sampAddChatMessage(("[RTIMER]: Первый запуск на этом сервере с этим ником. Создан "..serverip.."-"..playernick..".ini"), color)
    end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------------------------ПРИ ЗАГРУЗКЕ----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function onload()
  asodkas, licenseid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  licensenick = sampGetPlayerNickname(licenseid)
  sampRegisterChatCommand('rtimernot', cmdScriptInform)
  sampRegisterChatCommand('rtimer', scriptmenu)
  sampRegisterChatCommand('rtime', rtime)
  if settings.options.startmessage == 1 then
    sampAddChatMessage(('RTIMER v'..thisScript().version..' запущен. <> by qrlk.'),
    color)
    sampAddChatMessage(('Подробнее - /rtimer. Отключить это сообщение - /rtimernot'), color)
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------G U I-------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function cmdScriptInfo()
  sampShowDialog(2342, "{348cb2}RTIMER v"..thisScript().version..". Автор: qrlk.", "{ffcc00}Зачем этот скрипт?\n{ffffff}Скрипт создавался для удобного отсчета времени там, где это нужно в SA:MP.\nВ скрипте использованы разработки FYP'a и makaron'a, за которые им ~ спасибо.\nТаймер задротства можно использовать где угодно, остальное - только на Samp-Rp.\n\n{ffcc00}Таймер угона (Samp-Rp).\n{ffffff}Представляет собой удобную штуку для угонщиков samp-rp.\nСоздаёт textdraw с обратным отсчетом до следующего угона.\nОтслеживает количество удачных и не очень угонов, а так же заработанные бабки.\nСтатистику угона можно посмотреть в {00ccff}/rtimer{ffffff}.\nВ настройках можно изменить шрифт textdraw'a, его размер и положение, поменять\nзадержку, выключить гудок и вовсе отключить функцию.\nКогда время истечёт, в чате будет уведомление и звук гудка, а textdraw поменяет цвет.\n\n{ffcc00}Таймер нарко (Samp-Rp).\n{ffffff}Представляет собой доработанный и переписанный на Lua Drugs Master makaron'a.\nПо нажатию хоткея ({00ccff}X{ffffff} по умолчанию) скрипт автоматически юзнет нужное количество наркотиков.\nПосле нажатия запустится таймер до следующего употребления (/usedrugs).\nДержите хоткей ({00ccff}X{ffffff} по умолчанию), чтобы заюзать 1 грамм (помогает от ломки).\nВ автоматическом режиме скрипт отслеживает оставшееся количество нарко.\nВ настройках можно изменить хоткей, шрифт textdraw'ов, их размер и положение,\nпоменять задержку, изменить стиль \"Drugs\", выключить звук и вовсе отключить функцию.\n\n{ffcc00}Таймер дальнобойщика (Samp-Rp).\n{ffffff}Вырезан в 1.81 по причине наличия более удачной реализации идеи.\nЯ не дальнобой и писал на отъебись эту часть скрипта.\nИспользуйте TruckHUD.lua\n\n{ffcc00}Таймер задротства.\n{ffffff}Функция считает время вашей игры за день (обнуляется при изменении даты в 05:00).\nЕсть возможность установить лимит, как у родительского контроля.\nПри достижении лимита на экране появится textdraw.\nВведите {00ccff}/rtime{ffffff}, чтобы узнать сколько вы наиграли, текущий лимит и остаток.\nВведите {00ccff}/rtime 0{ffffff}, чтобы удалить лимит в принципе.\nВведите {00ccff}/rtime [ЧЧ:ММ]{ffffff}, чтобы установить новый лимит в часах и минутах.\n\n{ffcc00}Доступные команды:\n    {00ccff}/rtimer {ffffff}- главное меню скрипта.\n    {00ccff}/rtime {ffffff}- таймер задротства.\n{00ccff}    /rtimernot{ffffff} - включить/выключить сообщение при входе в игру.", "Лады")
end
--------------------------------------------------------------------------------
-------------------------------------М Е Н Ю------------------------------------
--------------------------------------------------------------------------------
function menu()
  submenus_show(mod_submenus_sa, '{348cb2}RTIMER v'..thisScript().version..' by qrlk.', 'Выбрать', 'Закрыть', 'Назад')
end
function scriptmenu()
  menutrigger = 1
end
mod_submenus_sa = {
  {
    title = 'Информация о скрипте',
    onclick = function()
      wait(100)
      cmdScriptInfo()
    end
  },
  {
    title = 'Статистика угона',
    onclick = function()
      wait(100)
      cmdGetUgonStats()
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
        title = 'Вкл/выкл уведомление при запуске',
        onclick = function()
          cmdScriptInform()
        end
      },
      {
        title = 'Вкл/выкл автообновление',
        onclick = function()
          if settings.options.autoupdate == 1 then
            settings.options.autoupdate = 0 sampAddChatMessage(('[RTIMER]: Автообновление выключено'), color)
          else
            settings.options.autoupdate = 1 sampAddChatMessage(('[RTIMER]: Автообновление включено'), color)
          end
          saveini(1)
        end
      },
    }
  },
  {
    title = 'Настройки таймера угона',
    submenu = {
      {
        title = 'Включить/выключить таймер угона',
        onclick = function()
          lua_thread.create(cmdChangeUgonActive)
        end
      },
      {
        title = ' '
      },
      {
        title = 'Изменить задержку угона',
        onclick = function()
          lua_thread.create(cmdChangeUgonDelay)
        end
      },
      {
        title = 'Включить/выключить гудок',
        onclick = function()
          cmdChangeUgonSoundActive()
        end
      },
      {
        title = ' '
      },
      {
        title = '{AAAAAA}Настройки TextDraw'
      },
      {
        title = 'Настройки "UgonTimer"',
        submenu = {
          {
            title = '[0] Изменить шрифт "UgonTimer"',
            submenu = {
              {
                title = '[0] "The San Andreas Font"',
                onclick = function()
                  cmdChangeUgonTxdStyle(0)
                end
              },
              {
                title = '[1] "Both case characters"',
                onclick = function()
                  cmdChangeUgonTxdStyle(1)
                end
              },
              {
                title = '[2] "Only capital letters"',
                onclick = function()
                  cmdChangeUgonTxdStyle(2)
                end
              },
              {
                title = '[3] "Стандартный"',
                onclick = function()
                  cmdChangeUgonTxdStyle(3)
                end
              },
            },
          },
          {
            title = '[1] Изменить положение и размер "UgonTimer"',
            submenu = {
              {
                title = '[0] Изменить положение и размер "UgonTimer"',
                onclick = function()
                  cmdChangeUgonTimerPos(0)
                end
              },
              {
                title = '[1] Восстановить дефолтные настройки',
                onclick = function()
                  cmdChangeUgonTimerPos(1)
                end
              }
            },
          },
          {
            title = '[2] Восстановить дефолтные настройки',
            onclick = function()
              cmdDrugsUgonDefault()
            end
          }
        }
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
        title = ' '
      },
      {
        title = 'Изменить горячую клавишу',
        onclick = function()
          lua_thread.create(cmdChangeDrugsHotkey)
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
        title = 'Включить/выключить ПДИНЬ',
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
            title = '[0] Изменить стиль оформления "Drugs"',
            submenu = {
              {
                title = '[0] Выбрать тип оверлея - "Drugs"',
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
            title = '[1] Изменить шрифт "Drugs"',
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
            {
              title = '[4] Восстановить дефолтные настройки',
              onclick = function()
                cmdDrugsTxdDefault()
              end
            }
          },
          {
            title = '[2] Изменить положение и размер "Drugs"',
            submenu = {
              {
                title = '[0] Изменить положение и размер "Drugs"',
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
      {
        title = 'Настройки "DrugsTimer"',
        submenu = {
          {
            title = '[0] Изменить шрифт "DrugsTimer"',
            submenu = {
              {
                title = '[0] "The San Andreas Font"',
                onclick = function()
                  cmdChangeDrugsTimerTxdStyle(0)
                end
              },
              {
                title = '[1] "Both case characters"',
                onclick = function()
                  cmdChangeDrugsTimerTxdStyle(1)
                end
              },
              {
                title = '[2] "Only capital letters"',
                onclick = function()
                  cmdChangeDrugsTimerTxdStyle(2)
                end
              },
              {
                title = '[3] "Стандартный"',
                onclick = function()
                  cmdChangeDrugsTimerTxdStyle(3)
                end
              },
            },
          },
          {
            title = '[1] Изменить положение и размер "DrugsTimer"',
            submenu = {
              {
                title = '[0] Изменить положение и размер "DrugsTimer"',
                onclick = function()
                  cmdChangeDrugsTimerPos(0)
                end
              },
              {
                title = '[1] Восстановить дефолтные настройки',
                onclick = function()
                  cmdChangeDrugsTimerPos(1)
                end
              }
            },
          },
          {
            title = '[2] Восстановить дефолтные настройки',
            onclick = function()
              cmdDrugsTimerDefault()
            end
          }
        }
      },
      {
        title = 'Восстановить дефолтные настройки',
        onclick = function()
          cmdDrugsTxdDefault()
          cmdDrugsTimerDefault()
        end
      }
    }
  },
  {
    title = 'Настройки таймера дальнобоя',
    submenu = {
      {
        title = 'Вкл/выкл рендер дальнобоя',
        onclick = function()
          sampAddChatMessage('[RTIMER]: Дальнобой вырезан из RTIMER. Используйте TruckHUD.', color)
        end
      },
    }
  },
  {
    title = 'Настройки таймера задротства',
    submenu = {
      {
        title = 'Изменить/удалить лимит',
        onclick = function()
          lua_thread.create(rtime, 228966)
        end
      },
      {
        title = ' '
      },
      {
        title = '{AAAAAA}Настройки TextDraw'
      },
      {
        title = 'Настройки "ZadrotLimit"',
        submenu = {
          {
            title = '[0] Изменить шрифт "ZadrotLimit"',
            submenu = {
              {
                title = '[0] "The San Andreas Font"',
                onclick = function()
                  cmdChangeZadrotTimerTxdStyle(0)
                end
              },
              {
                title = '[1] "Both case characters"',
                onclick = function()
                  cmdChangeZadrotTimerTxdStyle(1)
                end
              },
              {
                title = '[2] "Only capital letters"',
                onclick = function()
                  cmdChangeZadrotTimerTxdStyle(2)
                end
              },
              {
                title = '[3] "Стандартный"',
                onclick = function()
                  cmdChangeZadrotTimerTxdStyle(3)
                end
              },
            },
          },
          {
            title = '[1] Изменить положение и размер "ZadrotLimit"',
            submenu = {
              {
                title = '[0] Изменить положение и размер "UgonTimer"',
                onclick = function()
                  cmdChangeZadrotTimerPos(0)
                end
              },
              {
                title = '[1] Восстановить дефолтные настройки',
                onclick = function()
                  cmdChangeZadrotTimerPos(1)
                end
              }
            },
          },
          {
            title = '[2] Изменить текст лимита',
            onclick = function()
              lua_thread.create(cmdZadrotTimerText)
            end
          },
          {
            title = '[3] Восстановить дефолтные настройки',
            onclick = function()
              cmdZadrotTimerDefault()
            end
          }
        }
      },
    }
  },

  {
    title = 'Сбросить настройки (не статистику)',
    onclick = function()
      resetsettings()
    end
  },
  {
    title = ' '
  },
  {
    title = '{AAAAAA}Разное'
  },
  {
    title = 'Связаться с автором (все баги сюда)',
    onclick = function()
      os.execute('explorer "http://qrlk.me/sampcontact"')
    end
  },
  {
    title = ' '
  },
  {
    title = '{AAAAAA}Обновления'
  },
  {
    title = 'Подписывайтесь на группу ВКонтакте!',
    onclick = function()
      os.execute('explorer "http://qrlk.me/sampvk"')
    end
  },
  {
    title = 'Открыть страницу скрипта',
    onclick = function()
      os.execute('explorer "http://qrlk.me/samp/rtimer"')
    end
  },
  {
    title = 'История обновлений',
    onclick = function()
        os.execute('explorer "http://qrlk.me/changelog/rtimer"')
    end
  },
}
function resetsettings()
  sampShowDialog(988, "Сброс настроек", string.format("Все настройки скрипта будут сброшены, кроме статистики угона и счётчика задротства.\nЗначение лимита будет сброшено, но количество наигранных за день секунд - нет.\nЧтобы продолжить, введите 'go'"), "Выбрать", "Закрыть", 1)
  while sampIsDialogActive(988) do wait(100) end
  local resultMain, buttonMain, typ = sampHasDialogRespond(988)
  if buttonMain == 1 and sampGetCurrentDialogEditboxText(988) == "go" then
    settings.options.startmessage = 1
    settings.ugon.isactive = 1
    settings.ugon.cooldown = 900
    settings.ugon.sound = 1
    settings.ugon.istxdactive = 1
    settings.ugon.posX1 = 588
    settings.ugon.posY1 = 428
    settings.ugon.size1 = 0.5
    settings.ugon.size2 = 2
    settings.ugon.style1 = 3
    settings.usedrugs.isactive = 1
    settings.usedrugs.sound = 1
    settings.usedrugs.txdtype = 1
    settings.usedrugs.cooldown = 60
    settings.usedrugs.posX1 = 56
    settings.usedrugs.posY1 = 424
    settings.usedrugs.size1 = 0.6
    settings.usedrugs.size2 = 1.2
    settings.usedrugs.style1 = 3
    settings.usedrugs.posX2 = 80
    settings.usedrugs.posY2 = 315
    settings.usedrugs.size3 = 0.4
    settings.usedrugs.size4 = 2
    settings.usedrugs.style2 = 3
    settings.usedrugs.key = 88
    settings.zadrottimer.style1 = 3
    settings.zadrottimer.posX1 = 591
    settings.zadrottimer.posY1 = 418
    settings.zadrottimer.size1 = 0.5
    settings.zadrottimer.size2 = 1.3
    settings.zadrottimer.text = "Limit"
    settings.zadrottimer.limit = 0
    if inicfg.save(settings, "rtimer\\settings") then
      sampAddChatMessage("[RTIMER]: Настройки сброшены. Скрипт будет перезапущен.", color)
      local script = thisScript()
      script:reload()
    end
  end
end
--------------------------------------------------------------------------------
--------------------------------НАСТРОЙКИ СКРИПТА-------------------------------
--------------------------------------------------------------------------------
function cmdScriptInform()
  if settings.options.startmessage == 1 then
    settings.options.startmessage = 0 sampAddChatMessage(('Уведомление активации RTIMER при запуске игры отключено'), color)
  else
    settings.options.startmessage = 1 sampAddChatMessage(('Уведомление активации RTIMER при запуске игры включено'), color)
  end
  saveini(1);
end
-- DO NOT TOUCH
function onScriptTerminate(LuaScript, bool)
  if LuaScript == thisScript() and bool == false then
    intim.usedrugs.lasttime = 0
    sampTextdrawDelete(421)
    sampTextdrawDelete(420)
    sampTextdrawDelete(419)
    sampTextdrawDelete(422)
    sampTextdrawDelete(423)
    sampTextdrawDelete(424)
    saveini(1)
    saveini(2)
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-----------------------------------НЕ ТРОГАТЬ-----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------------------------SAVERS-------------------------------------
--------------------------------------------------------------------------------
function saveini(param)
  local parampampam = tonumber(param)
  if parampampam == 1 then inicfg.save(settings, "rtimer\\settings") end
  if parampampam == 2 then inicfg.save(intim, 'rtimer\\'..serverip..'-'..playernick) end
end
-- made by FYP
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
