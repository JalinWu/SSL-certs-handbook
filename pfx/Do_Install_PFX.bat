@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Do_Install_PFX.txt"
SET "pfxDir=%currentPath%..\cert\pfx"
SET "caDir=%currentPath%..\cert\ca"

IF %thumbprint%=="" (
    ECHO Error: Empty Thumbprint
    GOTO PROCESS_ERROR
)

:: Get file
IF NOT EXIST %pfxDir% (
    ECHO %pfxDir%, PFX folder does not exist.
    GOTO PROCESS_ERROR
)
IF NOT EXIST %caDir% (
    ECHO %caDir%, CA folder does not exist.
    GOTO PROCESS_ERROR
)

FOR %%A IN ("%pfxDir%\*") DO (
    SET pfxFileName=%%~nxA
    GOTO :FoundPFX
)
:FoundPFX
IF DEFINED pfxFileName (
    ECHO PFX file: %pfxFileName%
) ELSE (
    ECHO PFX file does not exist.
    GOTO PROCESS_ERROR
)

FOR %%A IN ("%caDir%\*") DO (
    SET caFileName=%%~nxA
    GOTO :FoundCA
)
:FoundCA
IF DEFINED caFileName (
    ECHO CA file: %caFileName%
) ELSE (
    ECHO CA file does not exist.
    GOTO PROCESS_ERROR
)

:: Check if pfx is in IIS
CERTUTIL -store My | findstr /i %thumbprint% >%logfile% 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO PFX is exist
    GOTO IMPORT_CA
)

:: Run command to install PFX
ECHO Run command to install PFX
SET pfxPath=%pfxDir%/%pfxFileName%
CERTUTIL -p %password% -importPFX "%pfxPath%" >>%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: CERTUTIL -p %password% -importPFX "%pfxPath%"
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)

:: Run command to import ca
:: No need to check
:IMPORT_CA
ECHO Run command to import CA
SET caPath=%caDir%/%caFileName%
CERTUTIL -addstore -f Root "%caPath%" >>%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: CERTUTIL -addstore -f Root "%caPath%"
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)


:PROCESS_SUCCESS
ECHO Run Install PFX command successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Run Install PFX command failed
EXIT /b 1
