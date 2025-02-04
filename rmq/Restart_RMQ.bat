@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Restart_RMQ.txt"
SET "serviceName=RabbitMQ"

::Stop RabbitMQ
ECHO Find RabbitMQ PID
FOR /F "tokens=3" %%A IN ('sc queryex "%serviceName%" ^| findstr PID') DO (SET pid=%%A)
IF %pid% EQU 0 (
    ECHO %serviceName% is not Running
    GOTO START_RMQ
)

ECHO kill PID: %pid%
taskkill /F /PID %pid% >%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: taskkill /F /PID %pid%
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)

::Start RabbitMQ
:START_RMQ
ECHO start RabbitMQ
sc start %serviceName% >>%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: sc start %serviceName%
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)

IF EXIST %logfile% (del %logfile%)
ECHO Restart RabbitMQ successfully
EXIT /b 0

:PROCESS_ERROR
IF EXIST %logfile% (del %logfile%)
ECHO Restart RabbitMQ failed
EXIT /b 1

