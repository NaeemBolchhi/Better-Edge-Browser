@echo off
setlocal enabledelayedexpansion

set "_source=%~dp0debloat-source\generated"
set "_target=%~dp0"

set "_linux=%_source%\linux\edge.json"
set "_macos=%_source%\macos\edge.mobileconfig"
set "_windows=%_source%\windows\edge.reg"

move /y "%_linux%" "%_target%"
move /y "%_macos%" "%_target%"
move /y "%_windows%" "%_target%\edge-add.reg"

rmdir /s /q "%_source%"

set "_input=edge-add.reg"
set "_temp=edge-add.tmp"

> "%_temp%" (
    for /f "delims=" %%A in (%_input%) do (
        set "line=%%A"
        set "line=!line:'=\"!"
        echo(!line!
    )
)

move /y "%_temp%" "%_input%" >nul

timeout 1