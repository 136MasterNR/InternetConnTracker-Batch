@ECHO OFF
::HTS-Studios | Contact us at https://discord.gg/Qst63njdBG
MODE CON:COLS=71 LINES=1
TITLE Checking connection...
IF EXIST "settings.cmd" ( CALL "settings.cmd" ) ELSE (
	(
		ECHO.:LogLive
		ECHO.SET "maxLogSize=150000"^&REM : If the log size is higher, LogLive will stop. Higher values will make the logger slower. DEFAULT: "150000"
		ECHO.SET "resetLogIfLarge=FALSE"^&REM : If the log is larger than maximum, it will reset the log file instead of stopping the LogLive. DEFAULT: "FALSE"
		ECHO.SET "colorLogGreen=[1;32m"^&REM : What color should the 'connected' be when live logging? Leave empty to disable this color. DEFAULT: "[1;32m"
		ECHO.SET "colorLogRed=[1;31m"^&REM : What color should the 'disconnected' be when live logging? Leave empty to disable this color. DEFAULT: "[1;31m"
		ECHO.
		ECHO.:InternetConnTracker
		ECHO.SET "beepOnLostConn=TRUE"^&REM : Make a sound when a lag spike is detected. DEFAULT: "TRUE"
		ECHO.SET "autoStartLogLive=TRUE"^&REM : Start LogLive.bat when you start InternetConnTracket. DEFAULT: "TRUE"
		ECHO.SET "logFile=TrackLogger.log"^&REM : Where to log the file. Leave empty to not log. DEFAULT: "TrackLogger.log"
		ECHO.SET "pingMethod=LOCALHOST"^&REM : On which IP adress to check for connection. DEFAULT: "LOCALHOST"
	)>"settings.cmd"
	CALL "settings.cmd"
)
IF "%autoStartLogLive%"=="TRUE" IF DEFINED logFile IF EXIST LogLive.bat START /I "" "LogLive.bat"
SET VERS=2.0.4
IF EXIST "%CD%\se-beep.mp3" IF NOT EXIST "%cd%\SE-BEEP.vbs" ( ( ECHO Set Sound = CreateObject("WMPlayer.OCX.7"^)&  ECHO Sound.URL = "se-beep.mp3"&  ECHO Sound.Controls.play&  ECHO do while Sound.currentmedia.duration = 0&  ECHO wscript.sleep 100&  ECHO loop&  ECHO wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >SE-BEEP.vbs )
SET /P "=Lost connection will be shown here."<NUL
IF DEFINED logFile BREAK>"%logFile%"
:LAUNCHER
SET CTIME=%TIME%
PING www.google.nl -n 1 -w 1000 >NUL
IF ERRORLEVEL 1 (
	SET CONN=FALSE
	IF /I "%ERRORLEVEL%"=="1" IF "%beepOnLostConn%"=="TRUE" IF EXIST "%CD%\SE-BEEP.vbs" IF EXIST "%CD%\se-beep.mp3" START "" "SE-BEEP.vbs"
	::MODE CON:COLS=71 LINES=1
	CLS
	TITLE ^(%TIME%^) You're not connected to internet, or the connection is slow.&SET /P "=Lost connection at %time%"<NUL
	IF DEFINED logFile ECHO.%colorLogRed%At %CTIME% to %TIME% ^(X^)	Lost Connection>>"%logFile%"
	TASKLIST /FI "IMAGENAME eq wscript.exe" 2>NUL|FIND /I /N "wscript.exe">NUL
 ) ELSE (
	SET CONN=TRUE
	TITLE ^(%TIME%^) You're connected to internet.
	IF DEFINED logFile ECHO.%colorLogGreen%At %CTIME% to %TIME% ^(+^)	Connected>>"%logFile%"
)
IF "%CONN%"=="TRUE" ( PING %pingMethod% -n 1 -w 100 >NUL ) ELSE ( PING %pingMethod% -n 1 -w 500 >NUL )
GOTO LAUNCHER
EXIT