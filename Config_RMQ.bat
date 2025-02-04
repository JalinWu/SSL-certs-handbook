@ECHO OFF

SET "enable=%1"
SET "currentPath=%~dp0"
SET "doConfigRMQ=%currentPath%rmq/Do_Config_RMQ.bat"
SET "doRemoveConfig=%currentPath%rmq/Do_Remove_Config.bat"
SET "restartRMQ=%currentPath%rmq/Restart_RMQ.bat"
SET "doRestartRMQ=1"

:: Start do add/remove config
IF NOT EXIST "%doConfigRMQ%" (
    ECHO %doConfigRMQ% not exist
    GOTO PROCESS_ERROR
)
IF NOT EXIST "%doRemoveConfig%" (
    ECHO %doRemoveConfig% not exist
    GOTO PROCESS_ERROR
)
IF NOT EXIST "%restartRMQ%" (
    ECHO %restartRMQ% not exist
    GOTO PROCESS_ERROR
)

IF %enable%=="true" (
    ECHO [Config RMQ]
    CALL %doConfigRMQ%
) ELSE (
    ECHO [Remove RMQ Config]
    CALL %doRemoveConfig%
)
IF %ERRORLEVEL% NEQ 0 (GOTO PROCESS_ERROR)

::Restart RabbitMQ
IF %doRestartRMQ% EQU 1 (
    ECHO [Restart RabbitMQ]
    CALL %restartRMQ%
    IF %ERRORLEVEL% NEQ 0 (GOTO PROCESS_ERROR)
)

ECHO Process RabbitMQ config successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Process RabbitMQ config failed
EXIT /b 1
