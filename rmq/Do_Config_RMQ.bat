@ECHO OFF

ECHO CALL "%~f0"

SET "currentPath=%~dp0"
SET "logfile=%currentPath%Do_Config_RMQ.txt"
SET workDir=""
SET "GetWorkDirBat=%currentPath%Get_WorkDir.bat"
SET "updateConfBat=%currentPath%Update_Conf.bat"
SET "rabbitmqConf=%currentPath%rabbitmq.conf"

IF NOT EXIST "%GetWorkDirBat%" (
    ECHO %GetWorkDirBat% not exist
    GOTO PROCESS_ERROR
)
IF NOT EXIST "%updateConfBat%" (
    ECHO %updateConfBat% not exist
    GOTO PROCESS_ERROR
)

:: Get WorkDir
ECHO Get RabbitMQ installed path
CALL "%GetWorkDirBat%"
IF %ERRORLEVEL% NEQ 0 (GOTO PROCESS_ERROR)

:: Update rabbitmq.conf in rmq
ECHO Update rabbitmq.conf
CALL %updateConfBat%
IF %ERRORLEVEL% NEQ 0 (GOTO PROCESS_ERROR)

:: Copy rabbitmq.conf to WorkDir
ECHO Copy rabbitmq.conf to RabbitMQ installed path
IF NOT EXIST "%rabbitmqConf%" (
    ECHO "%rabbitmqConf%" does not exist.
    GOTO PROCESS_ERROR
)
COPY %rabbitmqConf% %workDir% >%logfile% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO ##### ERROR #####
    ECHO command: COPY %rabbitmqConf% %workDir%
    type %logfile%
    ECHO #################
    GOTO PROCESS_ERROR
)



ECHO Do Configure RabbitMQ successfully
EXIT /b 0

:PROCESS_ERROR
ECHO Do Configure RabbitMQ failed
EXIT /b 1
