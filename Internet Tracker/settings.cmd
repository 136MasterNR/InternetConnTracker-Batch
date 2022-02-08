:LogLive
SET "maxLogSize=150000"&REM : If the log size is higher, LogLive will stop. Higher or very low values will make the logger slower. Recommended Values: 300 ~ 200000. DEFAULT: "150000"
SET "resetLogIfLarge=FALSE"&REM : If the log is larger than maximum, it will reset the log file instead of stopping the LogLive. DEFAULT: "FALSE"
SET "colorLogGreen=[1;32m"&REM : What color should the 'connected' be when live logging? Leave empty to disable this color. DEFAULT: "[1;32m"
SET "colorLogRed=[1;31m"&REM : What color should the 'disconnected' be when live logging? Leave empty to disable this color. DEFAULT: "[1;31m"

:InternetConnTracker
SET "beepOnLostConn=TRUE"&REM : Make a sound when a lag spike is detected. DEFAULT: "TRUE"
SET "autoStartLogLive=TRUE"&REM : Start LogLive.bat when you start InternetConnTracket. DEFAULT: "TRUE"
SET "logFile=TrackLogger.log"&REM : Where to log the file. Leave empty to not log. DEFAULT: "TrackLogger.log"
SET "pingMethod=LOCALHOST"&REM : On which IP adress to check for connection. DEFAULT: "LOCALHOST"
