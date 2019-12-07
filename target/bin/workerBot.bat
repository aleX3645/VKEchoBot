@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\com\vk\api\sdk\0.5.12\sdk-0.5.12.jar;"%REPO%"\com\google\code\gson\gson\2.8.1\gson-2.8.1.jar;"%REPO%"\org\asynchttpclient\async-http-client\2.0.33\async-http-client-2.0.33.jar;"%REPO%"\org\asynchttpclient\async-http-client-netty-utils\2.0.33\async-http-client-netty-utils-2.0.33.jar;"%REPO%"\io\netty\netty-buffer\4.0.48.Final\netty-buffer-4.0.48.Final.jar;"%REPO%"\io\netty\netty-codec-http\4.0.48.Final\netty-codec-http-4.0.48.Final.jar;"%REPO%"\io\netty\netty-codec\4.0.48.Final\netty-codec-4.0.48.Final.jar;"%REPO%"\io\netty\netty-handler\4.0.48.Final\netty-handler-4.0.48.Final.jar;"%REPO%"\io\netty\netty-transport\4.0.48.Final\netty-transport-4.0.48.Final.jar;"%REPO%"\io\netty\netty-transport-native-epoll\4.0.48.Final\netty-transport-native-epoll-4.0.48.Final-linux-x86_64.jar;"%REPO%"\io\netty\netty-common\4.0.48.Final\netty-common-4.0.48.Final.jar;"%REPO%"\org\asynchttpclient\netty-resolver-dns\2.0.33\netty-resolver-dns-2.0.33.jar;"%REPO%"\org\asynchttpclient\netty-resolver\2.0.33\netty-resolver-2.0.33.jar;"%REPO%"\org\asynchttpclient\netty-codec-dns\2.0.33\netty-codec-dns-2.0.33.jar;"%REPO%"\org\reactivestreams\reactive-streams\1.0.0\reactive-streams-1.0.0.jar;"%REPO%"\com\typesafe\netty\netty-reactive-streams\1.0.8\netty-reactive-streams-1.0.8.jar;"%REPO%"\org\apache\commons\commons-collections4\4.1\commons-collections4-4.1.jar;"%REPO%"\commons-io\commons-io\2.5\commons-io-2.5.jar;"%REPO%"\org\apache\httpcomponents\httpclient\4.5.3\httpclient-4.5.3.jar;"%REPO%"\org\apache\httpcomponents\httpcore\4.4.6\httpcore-4.4.6.jar;"%REPO%"\commons-logging\commons-logging\1.2\commons-logging-1.2.jar;"%REPO%"\commons-codec\commons-codec\1.9\commons-codec-1.9.jar;"%REPO%"\org\apache\httpcomponents\httpmime\4.5.3\httpmime-4.5.3.jar;"%REPO%"\org\apache\commons\commons-lang3\3.6\commons-lang3-3.6.jar;"%REPO%"\org\slf4j\slf4j-api\1.7.29\slf4j-api-1.7.29.jar;"%REPO%"\org\slf4j\slf4j-simple\1.7.21\slf4j-simple-1.7.21.jar;"%REPO%"\org\example\VKEchoBot\1.0-SNAPSHOT\VKEchoBot-1.0-SNAPSHOT.jar
set EXTRA_JVM_ARGUMENTS=
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="workerBot" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" VKServer %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
