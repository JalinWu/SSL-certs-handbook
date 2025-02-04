@ECHO OFF
setlocal enabledelayedexpansion

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "config_origin=%currentPath%_rabbitmq.conf"
SET "certPath=%currentPath%..\cert"

IF NOT EXIST "%config_origin%" (
    ECHO template of rabbitmq.conf not exist.
    GOTO PROCESS_ERROR
)

ECHO Set cacertfile
FOR %%A IN ("%certPath%\ca\*") DO (
    SET cacertfile=%certPath%\ca\%%~nxA
)
IF NOT DEFINED cacertfile (
    ECHO Error: cacert file does not exist.
    GOTO PROCESS_ERROR
)

ECHO Set certfile
FOR %%A IN ("%certPath%\server\*") DO (
    SET certfile=%certPath%\server\%%~nxA
)
IF NOT DEFINED certfile (
    ECHO Error: cert file does not exist.
    GOTO PROCESS_ERROR
)

ECHO Set keyfile
FOR %%A IN ("%certPath%\key\*") DO (
    SET keyfile=%certPath%\key\%%~nxA
)
IF NOT DEFINED keyfile (
    ECHO Error: key file does not exist.
    GOTO PROCESS_ERROR
)

(for /f "tokens=*" %%A in (%config_origin%) do (
    SET "line=%%A"
    for /f "tokens=1,* delims==" %%B in ("!line!") do (
        SET "key=%%B"
        SET "key=!key: =!"
        SET "value=%%C"
        SET "value=!value: =!"

        if "!key!"=="ssl_options.cacertfile" (
            ECHO !key!=%cacertfile%
        ) else if "!key!"=="web_mqtt.ssl.cacertfile" (
            ECHO !key!=%cacertfile%
        ) else if "!key!"=="ssl_options.certfile" (
            ECHO !key!=%certfile%
        ) else if "!key!"=="web_mqtt.ssl.certfile" (
            ECHO !key!=%certfile%
        ) else if "!key!"=="ssl_options.keyfile" (
            ECHO !key!=%keyfile%
        ) else if "!key!"=="web_mqtt.ssl.keyfile" (
            ECHO !key!=%keyfile%
        ) else (
            ECHO !key!=!value!
        )
    )
)) > %currentPath%rabbitmq.conf

ECHO Update rabbitmq.conf successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Update rabbitmq.conf failed
EXIT /b 1
