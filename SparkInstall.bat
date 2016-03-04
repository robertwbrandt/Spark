@ECHO OFF
REM     Script to install the OPW version of Spark
REM     Bob Brandt <projects@brandt.ie>
REM          
REM     Copyright (C) 2013 Free Software Foundation, Inc.
REM     License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
REM     This program is free software: you can redistribute it and/or modify it under
REM     the terms of the GNU General Public License as published by the Free Software
REM     Foundation, either version 3 of the License, or (at your option) any later
REM     version.
REM     This program is distributed in the hope that it will be useful, but WITHOUT ANY
REM     WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
REM     PARTICULAR PURPOSE.  See the GNU General Public License for more details.
REM

SET sparkversion=spark_2_7_5

SET working=%ProgramFiles(x86)%\Spark
IF "%ProgramFiles(x86)%" == "" SET working=%ProgramFiles%\Spark

SET shortcut=%ALLUSERSPROFILE%\Start Menu\Programs\Startup\Spark.lnk
SET icon=%working%\Spark.exe
SET args=-File \"%working%\SparkRun.ps1\"
SET desc=Instant Messaging Client

REM Install new client (only if needed)
IF NOT EXIST "%working%\%sparkversion%.txt" (
	TASKKILL /F /IM spark.exe 2> nul
	"C:\Spark\%sparkversion%.exe" -q 2> nul
	ECHO %sparkversion% > "%working%\%sparkversion%.txt"
	MOVE "%ALLUSERSPROFILE%\Start Menu\Programs\Spark\Spark.lnk" "%ALLUSERSPROFILE%\Start Menu\Programs\Spark\Spark (Original).lnk"
)

REM Copy new startup script
COPY /Y "C:\Spark\SparkRun.ps1" "%working%"

REM Create Startup Shortcut
SET cmd=$s=(New-Object -COM WScript.Shell).CreateShortcut('%shortcut%')
SET cmd=%cmd%;$s.TargetPath='PowerShell.exe'
SET cmd=%cmd%;$s.Arguments='%args%'
SET cmd=%cmd%;$s.IconLocation='%icon%, 0'
SET cmd=%cmd%;$s.WorkingDirectory='%working%'
SET cmd=%cmd%;$s.Description='%desc%'
SET cmd=%cmd%;$s.WindowStyle=7;$s.Save()
DEL /F "%shortcut%" 2> nul

PowerShell.exe "%cmd%"

COPY /Y "%shortcut%" "%ALLUSERSPROFILE%\Start Menu\Programs\Spark\Spark.lnk"
DEL /F "%PUBLIC%\Desktop\Spark.lnk"
EXIT /B

