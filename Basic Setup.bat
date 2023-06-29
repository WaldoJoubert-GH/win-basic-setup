@echo off

echo ##################################################################
echo #                                                                #
echo #                     F  I  R  M  L  I  N  X                     #
echo #                                                                #
echo # ####   ###   #### #####  ####     ####  #### ##### #   # ####  #
echo # #   # #   # #       #   #        #     #       #   #   # #   # #
echo # ####  #####  ###    #   #         ###  ###     #   #   # ####  #
echo # #   # #   #     #   #   #            # #       #   #   # #     #
echo # ####  #   # ####  #####  ####    ####   ####   #    ###  #     #
echo #                                                                #
echo ##################################################################
echo Created by Pieter Scutte
echo Redone/ Updated by Waldo Joubert
echo.
openfiles > NUL 2>&1 
if NOT %ERRORLEVEL% EQU 0 goto NotAdmin

echo Please ensure that you are connected to the internet before continuing.

echo Actions to be performed:
echo - Set Device Name.
echo - Set Type of Device 
echo - Enable Desktop Icons
echo - Install Adobe Reader, CutePDF, Java, Chrome, AnyDesk and WinRAR
echo - For Client add Teamviewer Quick Support shortcut and Firmlinx shortcut
echo - Create FL-Admin Administrator User

pause

pushd %~dp0\Software

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

if %version%==6.1 set ver=Windows 7
if %version%==6.2 set ver=Windows 8
if %version%==6.3 set ver=Windows 8.1
if %version%==10.0 set ver=Windows 10

echo.
echo ---PC-Version---
echo Detected Windows Version: %ver% - %processor_architecture%

echo.
echo ---PC_Name---
set /p pcName="Enter a new meaningful (eg. John-Desktop) Computer Name: "
WMIC COMPUTERSYSTEM where name="%computername%" CALL RENAME name="%pcName%"

echo.
echo ---UnHideDesktopIcons---
echo Enabling desktop icons
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031A47-3F72-44A7-89C5-5595FE6B30EE} /t REG_DWORD /d 0 /f

echo.
echo --DestopIcons---
echo Adding Desktop Icons
for %%b in (*.reg) do (
	start /WAIT regedit /s %%b
)

:AnyDesk
echo.
echo ---AnyDesk---
echo Installing AnyDesk
set anydesk=%systemdrive%\Firmlinx\AnyDesk
start /WAIT AnyDesk.exe --install "%anydesk%" --start-with-win --silent --create-desktop-icon --create-shortcuts
echo F1rmt3ch@777 | %anydesk%\anydesk.exe --set-password

echo.
echo ---AdobeReader---
echo Installing Adobe Reader DC
start /WAIT AcroRdrDC.exe /sAll

echo.
echo ---Java---
echo Installing Java
start /WAIT jre-i586.exe /s
if %processor_architecture%==AMD64 start /WAIT jre-x64.exe /s

echo.
echo ---Google-Chrome---
echo Installing Google Chrome
start /WAIT ChromeSetup.exe

echo.
echo ---WinRAR--
echo Installing WinRAR
if %processor_architecture%==x86 start /WAIT wrar59b3.exe 
if %processor_architecture%==AMD64 start /WAIT winrar-x64-59b3.exe

:Shortcuts
cd ..
pushd %~dp0\Shortcuts

:TeamViewer
echo.
echo ---TeamViewer---
set teamViewer=%systemdrive%\Firmlinx\TeamViewer\
echo Copying TeamViewer Dir:
xcopy /y /s "TeamViewer" "%teamViewer%"
echo Copying TeamViewerQS-Shortcut to desktop:
xcopy /y "TeamViewer.lnk" "%USERPROFILE%\Desktop\"

:UrlShortcut
echo.
echo ---Firmlinx-url---
echo Copying website shortcut:
xcopy /y "Frimlinx (Pty) Ltd.url" "%USERPROFILE%\Desktop\Frimlinx (Pty) Ltd.url"

:FL-Admin
Echo ---FL-Admin---
echo Creating FL-Admin
net user FL-Admin F1rmt3ch@777 /add
echo Making user Admin
net localgroup administrators FL-Admin /add
echo User is now Admin
goto END

pause

:NotAdmin
color 0c
echo Please run as administrator to continue.
pause
exit

:END
color 0a
echo.
echo ---Done---
echo Basic setup is succesfull.
echo Please restart and test applications.
pause