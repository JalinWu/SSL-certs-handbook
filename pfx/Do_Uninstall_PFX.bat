@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Do_Uninstall_PFX.txt"

:: IF not giving thumbprint, skip all process
IF %thumbprint%=="" (
    ECHO Empty Thumbprint, Skip Process
    GOTO PROCESS_SUCCESS
)

:: Check if pfx is in IIS
CERTUTIL -store My | findstr /i %thumbprint% >%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO PFX not exist
    GOTO PROCESS_SUCCESS
)

:: Run command to uninstall PFX
ECHO Run command to uninstall PFX by thumbprint: %thumbprint%
CERTUTIL -delstore My %thumbprint% >>%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: CERTUTIL -delstore My %thumbprint%
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)

:PROCESS_SUCCESS
ECHO Run Uninstall PFX command successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Run Uninstall PFX command failed
EXIT /b 1
