<h1 align="center">rtimer</h1>

<p align="center">

<img src="https://img.shields.io/badge/made%20for-GTA%20SA--MP-blue" >

<img src="https://img.shields.io/badge/Server-Samp--Rp%20|%20Any-red">

<img src="https://img.shields.io/github/languages/top/qrlk/rtimer">

<img src="https://img.shields.io/badge/dynamic/json?color=blueviolet&label=users%20%28active%29&query=result&url=http%3A%2F%2Fqrlk.me%2Fdev%2Fmoonloader%2Fusers_active.php%3Fscript%3Drtimer">

<img src="https://img.shields.io/badge/dynamic/json?color=blueviolet&label=users%20%28all%20time%29&query=result&url=http%3A%2F%2Fqrlk.me%2Fdev%2Fmoonloader%2Fusers_all.php%3Fscript%3Drtimer">

<img src="https://img.shields.io/date/1510779600?label=released" >

</p>

A **[moonloader](https://gtaforums.com/topic/890987-moonloader/)** script that adds several in-game timers useful for **[gta samp](https://sa-mp.com/)** (especially **[Samp-Rp](https://samp-rp.ru/)**) players.

It also requires **[CLEO 4+](http://cleo.li/?lang=ru)** and **[SAMPFUNCS 5+](https://blast.hk/threads/17/)**.

---

**The following description is in Russian, because it is the main language of the user base**.

# Описание 
Скрипт добавляет таймер автоугона, таймер наркотиков и счётчик задротства с огромным количеством функций.  
Предназначен для Samp-Rp, счётчик задротства работает везде.

**Требования:** [CLEO 4+](http://cleo.li/?lang=ru), [SAMPFUNCS 5+](https://blast.hk/threads/17/), [MoonLoader](https://blast.hk/threads/13305/).  
**Активация:** Скрипт активируется автоматом, а настроить его можно в собственной менюшке (/weather или /wat). В скрипте реализовано автообновление (можно отключить в настройках).

**Автор:** [qrlk](http://qrlk.me/samp).  
**Обсуждение в группе VK:** [ссылка](https://vk.com/topic-168860334_38597261). 
# Подробнее о каждом таймере
* **Таймер угона (Samp-Rp).**

    * Таймер предназначен для упрощения жизни угонщикам Samp-Rp.
    * Если функция активна, скрипт будет автоматически отслеживать количество удачных и неудачных угонов, число заработанных денег, общую статистику, а так же запускать таймер в углу экрана на 15 минут после завершения угона.
    * Огромным плюсом является возможность угонять с твинков: время последнего угона записывается в отдельный файл настроек, уникальный для каждого ника.
    * После релога таймер не сбрасывается.
    * В настройках можно изменить задержку, положение текстдрава, его шрифт, размер, отключить гудок и многое другое.

* **Таймер наркотиков (Samp-Rp).**

    * Таймер предназначен для упрощения жизни криминалу Samp-Rp.
    * Я думаю многие используют скрипт "Drugs Master" makaron'a, который жрет нужное количество нарко по нажатию горячей клавиши и выводит на экран количество оставшихся секунд. Мне он понравился, и я решил переписать его на Lua, доработав то, что меня бесило.
    * По нажатию горячей клавиши ("X" по умолчанию) скрипт высчитывает нужное количество нарко и жрёт его. Если нужно сожрать 1 грамм от ломки, достаточно подержать ту же клавишу.
    * При всём этом скрипт отслеживает количество оставшихся наркотиков, не давая сожрать больше остатка, ну и выводит на экран, отслеживая в чате следующие факторы:
    * Остаток наркотиков, который выводится при употреблении:
        * Покупка наркотиков в гетто.
        * Покупка нарко на Чёрном Рынке.
        * Покупка наркотиков с рук.
        * Продажа наркотиков с рук.
        * Ограбление больницы (байкеры).
    * В настройках можно изменить задержку, горячую клавишу, стиль "DRUGS" (просто надпись, надпись с остатком, просто остаток), положение текстдравов ("drugs" и самого таймера), его шрифт, размер, отключить звук, просто вырубить таймер и многое другое.

* **Таймер/счётчик задротства.**

    * Функция считает количество времени, проведенное в игре за сутки, начиная с 05:00.
    * Каждый день количество секунд обнуляется.
    * Чтобы посмотреть наигранное время, нужно ввести /rtime.
    * Есть возможность установки лимита (/rtime ЧЧ:ММ или из меню).
    * Когда будет достигнут лимит, на экране появится красный TextDraw "LIMIT".
    * Функция предназначена для людей, которые хотят себя ограничить во времени игры.
    * В настройках можно изменить текст TextDraw'a, его шрифт, размер и положение.

# Скриншоты
![https://i.imgur.com/JdqlCDo.png](https://i.imgur.com/JdqlCDo.png)  
![https://i.imgur.com/4D2CU7T.png?1](https://i.imgur.com/4D2CU7T.png?1)  
![https://i.imgur.com/ZuS5q53.jpg?1](https://i.imgur.com/ZuS5q53.jpg?1)  
![https://i.imgur.com/74c0pNc.jpg?1](https://i.imgur.com/74c0pNc.jpg?1)  
![https://i.imgur.com/pDOTlk0.jpg?1](https://i.imgur.com/pDOTlk0.jpg?1)  
![https://i.imgur.com/9VL9CJf.jpg?1](https://i.imgur.com/9VL9CJf.jpg?1)  


