:: this code sync source code frome service

set USER_NAME=service user name
set SERVICE_NAME=ip or domain
set SERVICE_PORT=service port defaute 22
set SYNC_DIR=need sync code dir
set SAVE_DIR=will save dir

if "%1" neq "" (
	set SERVICE_NAME=%1
)

if "%2" neq "" (
	set SYNC_DIR=%2
)

set SRC_DIR=/home/%USER_NAME%/work/%SYNC_DIR%
set DES_DIR=%SYNC_DIR%.tar.gz

if "%3" neq "" (
	set SAVE_DIR=%3
)

@echo "%SERVICE_NAME%"
@echo "%SYNC_DIR%"
@echo "%DES_DIR%"

ssh -p %SERVICE_PORT% %USER_NAME%@%SERVICE_NAME% "cd %SRC_DIR%/.. && tar -jcf %DES_DIR% %SYNC_DIR%;"
if "%errorlevel%" != 0 (
	echo "tar %SYNC_DIR% failed"
	pause
	exit 1
)

scp -P %SERVICE_PORT% %USER_NAME%@%SERVICE_NAME%:%SRC_DIR%/../%DES_DIR% %SAVE_DIR%
if "%errorlevel%" != 0 (
	echo "sync %SYNC_DIR% failed"
	pause
	exit 1
)

ssh -p %SERVICE_PORT% %USER_NAME%@%SERVICE_NAME% "cd %SRC_DIR%/.. && rm -rf %DES_DIR%;"
if "%errorlevel%" != 0 (
	echo "remove %DES_DIR% failed"
	pause
	exit 1
)

:: %1-host IP or domain  %2-sync dir %3-save dir
