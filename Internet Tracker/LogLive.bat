@ECHO OFF
SET OLL=OLDLOG
IF EXIST "settings.cmd" ( CALL "settings.cmd" ) ELSE ( ECHO.ERROR: COULD NOT LOAD "settings.cmd"
	TITLE LogLive: ERROR
	PAUSE>NUL
	EXIT /B
)
:LOGEXIST
IF NOT EXIST "%logFile%" (
	TITLE Waiting for log to start ... ^(%TIME%^)
	TIMEOUT /T 1 1>NUL 2>NUL >NUL
	GOTO LOGEXIST
)
TITLE Now Live Logging - %logFile%
:REPEAT
IF NOT EXIST "%logFile%" (
    ECHO.%colorLogRed%ERROR: %colorLogRed%The log file was not found.
	PAUSE>NUL&EXIT
) 1>NUL 2>NUL >NUL
FOR /F "usebackq" %%A IN ('%logFile%') DO SET SIZE=%%~zA
IF EXIST "%logFile%" IF %SIZE% GTR %maxLogSize% IF "%resetLogIfLarge%"=="FALSE" (
		ECHO.[0;1mERROR: %colorLogRed%The log is too large!
		PAUSE>NUL&EXIT
	) ELSE BREAK>"%logFile%"
)
SET LL=
IF EXIST "%logFile%" (
	FOR /F "UseBackQ delims==" %%A IN ("%logFile%") DO ( SET "LL=%%A" )
) 1>NUL 2>NUL >NUL
IF NOT EXIST "%logFile%" ( GOTO REPEAT )
IF NOT DEFINED LL ( GOTO REPEAT )
IF DEFINED LL IF "%OLL%"=="%LL%" GOTO SKIP
SET OLL=%LL%
ECHO.%LL%
:SKIP
GOTO REPEAT