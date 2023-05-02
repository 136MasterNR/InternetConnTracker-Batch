@ECHO OFF
::Rafu Studio  -  Distribution Allowed
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
		ECHO.SET "autoStartLogLive=TRUE"^&REM : Start LogLive.bat when you start InternetConnTracker. DEFAULT: "TRUE"
		ECHO.SET "logFile=TrackLogger.log"^&REM : Where to log the file. Leave empty to not log. DEFAULT: "TrackLogger.log"
		ECHO.SET "pingMethod=LOCALHOST"^&REM : On which IP adress to check for connection. DEFAULT: "LOCALHOST"
		ECHO.SET "pingWait=0"^&REM : How much time to wait after a ping request. DEFAULT: "1"
	)>"settings.cmd"
	CALL "settings.cmd"
)
IF "%autoStartLogLive%"=="TRUE" IF DEFINED logFile IF EXIST LogLive.bat START /I "" "LogLive.bat"
SET VERS=v2.8.0-stable
IF EXIST "%CD%\se-beep.mp3" IF NOT EXIST "%cd%\SE-BEEP.vbs" ( ( ECHO Set Sound = CreateObject("WMPlayer.OCX.7"^)&  ECHO Sound.URL = "se-beep.mp3"&  ECHO Sound.Controls.play&  ECHO do while Sound.currentmedia.duration = 0&  ECHO wscript.sleep 100&  ECHO loop&  ECHO wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >SE-BEEP.vbs )
SET /P "=Lost connection will be shown here."<NUL
IF DEFINED logFile BREAK>"%logFile%"
SETLOCAL EnableDelayedExpansion
:LAUNCHER
SET CTIME=%TIME%
SET "startTime=%time: =0%"
PING %pingMethod% -n 1 -w 1000 >NUL
SET "endTime=%time: =0%"
SET "end=!endTime:%time:~8,1%=%%100)*100+1!"&SET "start=!startTime:%time:~8,1%=%%100)*100+1!"
SET /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
SET /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
IF ERRORLEVEL 1 (
	SET CONN=FALSE
	IF /I "%ERRORLEVEL%"=="1" IF "%beepOnLostConn%"=="TRUE" IF EXIST "%CD%\SE-BEEP.vbs" IF EXIST "%CD%\se-beep.mp3" START "" "SE-BEEP.vbs"
	CLS
	TITLE ^(%TIME%^) You're not connected to internet, or the connection is slow.&SET /P "=Lost connection at %time%"<NUL
	IF DEFINED logFile ECHO.%colorLogRed%At %CTIME% to %TIME% ^(X^)	Lost Connection>>"%logFile%"
	TASKLIST /FI "IMAGENAME eq wscript.exe" 2>NUL|FIND /I /N "wscript.exe">NUL
 ) ELSE (
	SET CONN=TRUE
	TITLE ^(%TIME%^) You're connected to internet - Your Delay: %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1% ms
	IF DEFINED logFile ECHO.%colorLogGreen%At %CTIME% to %TIME% ^(+^)	Connected	Your Delay : %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1% ms>>"%logFile%"
)
TIMEOUT /T %pingWait% >NUL 2>NUL
GOTO LAUNCHER
EXIT