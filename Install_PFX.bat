@ECHO OFF

SET "enable=%1"
SET "password=%2"
SET "thumbprint=%3"
SET "currentPath=%~dp0"
SET "doInstallPFX=%currentPath%pfx\Do_Install_PFX.bat"
SET "doUninstallPFX=%currentPath%pfx\Do_Uninstall_PFX.bat"

:: Start do install/uninstall
REM IF %thumbprint%=="" (
    REM ECHO Error: thumbprint is null
    REM GOTO PROCESS_ERROR
REM )

IF NOT EXIST "%doInstallPFX%" (
    ECHO %doInstallPFX% not exist
    GOTO PROCESS_ERROR
)
IF NOT EXIST "%doUninstallPFX%" (
    ECHO %doUninstallPFX% not exist
    GOTO PROCESS_ERROR
)

IF %enable%=="true" (
    ECHO [Install PFX]
    CALL %doInstallPFX%
) ELSE (
    ECHO [Uninstall PFX]
    CALL %doUninstallPFX%
)
IF %ERRORLEVEL% NEQ 0 (GOTO PROCESS_ERROR)

ECHO Process PFX successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Process PFX failed
EXIT /b 1
