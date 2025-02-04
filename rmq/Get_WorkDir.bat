@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Get_WorkDir.txt"
SET "registryKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ericsson\Erlang\ErlSrv\1.1\RabbitMQ"
SET "valueName=WorkDir"

reg query "%registryKey%" /v "%valueName%" >%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO RabbitMQ installed path not found
    GOTO PROCESS_ERROR
) else (
    ECHO RabbitMQ installed path found
    for /f "tokens=2,*" %%A in ('reg query "%registryKey%" /v "%valueName%" ^| find "%valueName%"') do (
        SET workDir=%%B
        ECHO path: %%B
    )
)

@REM ECHO Get RabbitMQ installed path successfully
EXIT /b 0

:PROCESS_ERROR
@REM ECHO Get RabbitMQ installed path failed
EXIT /b 1
