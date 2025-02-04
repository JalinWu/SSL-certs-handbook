@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Do_Remove_RMQ.txt"
SET workDir=""
SET "GetWorkDirBat=%currentPath%Get_WorkDir.bat"

:: Get WorkDir
ECHO Get RabbitMQ installed path
CALL "%GetWorkDirBat%"
IF %ERRORLEVEL% NEQ 0 (
    SET doRestartRMQ=0
    GOTO PROCESS_SUCCESS
)

SET "rabbitmqConfInWorkDir=%workDir%\rabbitmq.conf"

IF NOT EXIST "%rabbitmqConfInWorkDir%" (
    ECHO %rabbitmqConfInWorkDir% not exist
    GOTO PROCESS_SUCCESS
)

:: Delete rabbitmq.conf file
ECHO Delete rabbitmq.conf: "%rabbitmqConfInWorkDir%"
DEL "%rabbitmqConfInWorkDir%" >%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: DEL "%rabbitmqConfInWorkDir%"
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)


:PROCESS_SUCCESS
ECHO Remove config successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Remove config failed
EXIT /b 1

