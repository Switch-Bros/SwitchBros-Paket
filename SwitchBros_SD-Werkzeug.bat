@echo off
SETLOCAL EnableDelayedExpansion
chcp 1252 >nul 2>&1
title SwitchBros. SD-Werkzeug
REM Dieses Skript basiert auf der Batch-Datei von rashevskyv seinem Kefir Paket
REM der ebenfalls Entwickler von DBI ist! RIESEN DANK!!! an diesen tollen Entwickler!

COLOR 0E
set wd=%temp%\sdfiles
set clear=0
set cfw=AMS
set cfwname=Atmosphere
set theme_flag=0
set theme=0
set sd=%1
REM if not defined %sd% (GOTO hauptmenue)

REM ================================================================================
:willkommen
type "%~dp0SwitchBros.txt"
pause>nul 2>&1

REM ================================================================================
:neuekarte
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo                     - WARNUNG - WARNUNG - WARNUNG -
echo. 
echo   Wenn du dieses Skript (SD-Werkzeug.bat) von deiner SD-Karte aus
echo   gestartet hast, dann schliesse es bitte sofort!
echo. 
echo   Starte die SD-Werkzeug.bat NUR aus dem "Basis" Ordner von deinem PC!
echo --------------------------------------------------------------------------------
echo.
echo   Hast du dieses Skript aus dem "SwitchBros_BasisPaket" aus gestartet, dann gib 
echo   jetzt bitte (NUR) den Laufwerksbuchstaben deiner SD-Karte ein!
echo.
echo --------------------------------------------------------------------------------
echo.

for /f "tokens=3-6 delims=: " %%a in ('WMIC LOGICALDISK GET FreeSpace^,Name^,Size^,filesystem^,description ^|FINDSTR /I "Removable" ^|findstr /i "exFAT FAT32"') do (@echo wsh.echo "Laufwerksbuchstabe: %%c;" ^& " frei: " ^& FormatNumber^(cdbl^(%%b^)/1024/1024/1024, 2^)^& " GB;"^& " Groesse: " ^& FormatNumber^(cdbl^(%%d^)/1024/1024/1024, 2^)^& " GB;" ^& " Dateisystem: %%a" > %temp%\tmp.vbs & @if not "%%c"=="" @echo( & @cscript //nologo %temp%\tmp.vbs & del %temp%\tmp.vbs)
echo.
set /P sd="Laufwerksbuchstabe der SD-Karte: "

if not exist "%sd%:\" (
	set word=        Es befindet sich keine SD-Karte im Laufwerk %sd%         
	GOTO falschesdkarte
) else (
	if not exist "%sd%:\*" (GOTO falschesdkarte)
)

REM ============================================================================
:modchip
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo   Wenn du einen Modchip in deiner Konsole hast, dann gib es bitte hier an!
echo. 
echo   1 = Modchip ist verbaut (v2, lite, OLED, trinketm0 in v1)
echo   2 = kein Modchip verbaut
echo.
echo --------------------------------------------------------------------------------
echo.

set /p modchip="Ist ein Modchip verbaut: "
if /i "%modchip%"=="1" SET bootdat=1
if /i "%modchip%"=="2" SET bootdat=0

REM ================================================================================
:datensichern
if exist "%sd%:\bootloader\hekate_ipl.ini" (xcopy /y "%sd%:\bootloader\hekate_ipl.ini" "%sd%:\switchbros\backup\*")
if exist "%sd%:\bootloader\nyx.ini" (xcopy /y "%sd%:\bootloader\nyx.ini" "%sd%:\switchbros\backup\*")
if exist "%sd%:\config\fastCFWSwitch\config.ini" (xcopy /y "%sd%:\config\fastCFWSwitch\config.ini" "%sd%:\switchbros\backup\fastCFWSwitch\*")
if exist "%sd%:\switch\tinfoil\locations.conf" (xcopy /y "%sd%:\switch\tinfoil\locations.conf" "%sd%:\switchbros\backup\tinfoil\*")

REM ================================================================================
:hauptmenue
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo          Dein altes Paket (egal welches) wird jetzt bereinigt!
echo.
echo          Du entscheidest wie es weiter geht Neo!
echo.
echo    1 = SD-Karte bereinigen und zum SwitchBros. Paket wechseln!
echo.
echo    2 = Backup Ordner auf deinem PC erstellen (fuer BOOT0, BOOT1, RAW GPP und KEYS)!
echo.
echo    3 = Gib deine Systempartitionen an (Linux, LAKKA, Android)!
echo.
echo    4 = Kinder-Modus einrichten (verstecken von Apps)!
echo.
echo    5 = ThemeApps Paket installieren/deinstallieren!
echo.
echo    6 = Tesla-Overlay installieren/deinstallieren/manuell!
echo.
echo    7 = Zusatz Apps installieren/deinstallieren!
echo.
echo    8 = Attribute (fixAttrib) und MacOS Kram beseitigen!
echo.
echo    9 = Volle USB3 Geschwindigkeit in die Registry eintragen lassen!
echo.
echo.
echo    F = Ich moechte mein altes Paket doch behalten!
echo.
echo    B = Dieses Skript Beenden!
echo.
echo --------------------------------------------------------------------------------
echo.

set /p neuistgut="Bitte gib deine Auswahl ein: "
if /i "%neuistgut%"=="1" GOTO sbgibgas
if /i "%neuistgut%"=="2" GOTO backupordner
if /i "%neuistgut%"=="3" GOTO systempartitionen
if /i "%neuistgut%"=="4" GOTO kindgerecht
if /i "%neuistgut%"=="5" GOTO themepaket
if /i "%neuistgut%"=="6" GOTO systemmodule
if /i "%neuistgut%"=="7" GOTO zusatzapps
if /i "%neuistgut%"=="8" GOTO attributeundmac
if /i "%neuistgut%"=="9" GOTO hekateusb
if /i "%neuistgut%"=="F" GOTO endefeige
if /i "%neuistgut%"=="B" GOTO endemutig

REM ================================================================================
:backupordner
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Bevor es losgeht, kann das Script fuer dich Backup-Ordner
echo     erstellen in denen du spaeter die Backups von hekate
echo     einfuegen kannst (BOOT0, BOOT1 und RAW GPP - Keys, etc.)
echo.
echo     Die erstellten Backups von hekate sind nicht gerade klein!              
echo     Gib bitte ein Laufwerk angeben das ueber ausreichend
echo     freien Speicherplatz verfuegt (ca. 35GB bzw. fuer OLED 65GB)!
echo.
echo     Folgende (leere) Ordner werden im angegebenen Laufwerk,
echo     auf deinem PC, fuer dich angelegt:
echo.             
echo   - SwitchBackup
echo      - sysNAND (fuer BOOT0, BOOT1 und RAW GPP)
echo      - Lockpick
echo         - Prodkeys-Devkeys (prod.keys und dev.keys)
echo         - Partial_AES_Keys (partial_aes.keys (Mariko Chip))
echo         - Amiibo_Keys
echo      - SD-Karten_Backup (CFW eingerichtet = Ein Backup davon)
echo.
echo.
echo     Brauchst du die Ordner nicht dann druecke nur die Eingabetaste!
echo.
echo --------------------------------------------------------------------------------
echo.
set "LW="
set /p LW=Bitte gib einen gueltigen Laufwerksbuchstaben ein: 

if defined LW (
 (
    md "%LW%:\SwitchBackup\sysNAND"
    md "%LW%:\SwitchBackup\Lockpick\Prodkeys-Devkeys"
    md "%LW%:\SwitchBackup\Lockpick\Partial_AES_Keys"
    md "%LW%:\SwitchBackup\Lockpick\Amiibo_Keys"
    md "%LW%:\SwitchBackup\SD-Karten_Backup"
  ) 2>nul
	echo.
	echo --------------------------------------------------------------------------------
	echo        Die Ordner fuer deine Backups wurden im Laufwerk "%LW%:\" erstellt
	echo.
	echo        Beliebige Taste um zum Hauptmenue zurueckzukehren!
	echo --------------------------------------------------------------------------------
	pause>nul 2>&1
	GOTO hauptmenue
) else (
    GOTO hauptmenue
)

REM ================================================================================
:endefeige
COLOR 09
echo. 
cls
echo --------------------------------------------------------------------------------
echo                       JA HAU DOCH AB DU LUTSCHA!!!
echo.
echo                      BLEIB BEI DEINEM BLOEDEN PAKET!
echo. 
echo                   Druecke die Eingabetaste zum beenden
echo --------------------------------------------------------------------------------

if exist "%wd%" (RD /s /q "%wd%\*")
pause>nul 2>&1
exit

REM ======= ATMOSPHERE ORDNER ======================================================
:sbgibgas
COLOR 0E
if exist "%sd%:\atmosphere\titles" (rename %sd%:\atmosphere\titles contents)
if exist "%sd%:\atmosphere\title" (rename %sd%:\atmosphere\title contents)
if exist "%sd%:\atmosphere\content" (rename %sd%:\atmosphere\content contents)

if exist "%sd%:\atmosphere\config" (RD /s /q "%sd%:\atmosphere\config")
if exist "%sd%:\atmosphere\erpt_reports" (RD /s /q "%sd%:\atmosphere\erpt_reports")
if exist "%sd%:\atmosphere\crash_reports" (RD /s /q "%sd%:\atmosphere\crash_reports")
if exist "%sd%:\atmosphere\exefs_patches" (RD /s /q "%sd%:\atmosphere\exefs_patches")
if exist "%sd%:\atmosphere\extras" (RD /s /q "%sd%:\atmosphere\extras")
if exist "%sd%:\atmosphere\fatal_errors" (RD /s /q "%sd%:\atmosphere\fatal_errors")
if exist "%sd%:\atmosphere\fatal_reports" (RD /s /q "%sd%:\atmosphere\fatal_reports")
if exist "%sd%:\atmosphere\flags" (RD /s /q "%sd%:\atmosphere\flags")
if exist "%sd%:\atmosphere\hosts" (RD /s /q  "%sd%:\atmosphere\hosts")
if exist "%sd%:\atmosphere\kip_patches" (RD /s /q "%sd%:\atmosphere\kip_patches")
if exist "%sd%:\atmosphere\logs" (RD /s /q  "%sd%:\atmosphere\logs")

if exist "%sd%:\atmosphere\package3" (del "%sd%:\atmosphere\package3")
if exist "%sd%:\atmosphere\*.bin" (del "%sd%:\atmosphere\*.bin")
if exist "%sd%:\atmosphere\*.nsp" (del "%sd%:\atmosphere\*.nsp")
if exist "%sd%:\atmosphere\*.romfs" (del "%sd%:\atmosphere\*.romfs")
if exist "%sd%:\atmosphere\*.sig" (del "%sd%:\atmosphere\*.sig")
if exist "%sd%:\atmosphere\*.json" (del "%sd%:\atmosphere\*.json")
if exist "%sd%:\atmosphere\*.ini" (del "%sd%:\atmosphere\*.ini")

REM ======= ATMOSPHERE CONTENTS ORDNER =============================================
if exist "%sd%:\atmosphere\contents\0100000000000008" (RD /s /q "%sd%:\atmosphere\contents\0100000000000008")
if exist "%sd%:\atmosphere\contents\010000000000100B" (RD /s /q "%sd%:\atmosphere\contents\010000000000100B")
if exist "%sd%:\atmosphere\contents\010000000000000D" (RD /s /q "%sd%:\atmosphere\contents\010000000000000D")
if exist "%sd%:\atmosphere\contents\010000000000002b" (RD /s /q "%sd%:\atmosphere\contents\010000000000002b")
if exist "%sd%:\atmosphere\contents\0100000000000032" (RD /s /q "%sd%:\atmosphere\contents\0100000000000032")
if exist "%sd%:\atmosphere\contents\0100000000000034" (RD /s /q "%sd%:\atmosphere\contents\0100000000000034")
if exist "%sd%:\atmosphere\contents\0100000000000036" (RD /s /q "%sd%:\atmosphere\contents\0100000000000036")
if exist "%sd%:\atmosphere\contents\0100000000000037" (RD /s /q "%sd%:\atmosphere\contents\0100000000000037")
if exist "%sd%:\atmosphere\contents\010000000000003C" (RD /s /q "%sd%:\atmosphere\contents\010000000000003C")
if exist "%sd%:\atmosphere\contents\0100000000000042" (RD /s /q "%sd%:\atmosphere\contents\0100000000000042")
if exist "%sd%:\atmosphere\contents\010000000000100C" (RD /s /q "%sd%:\atmosphere\contents\010000000000100C")
if exist "%sd%:\atmosphere\contents\010000000000100D" (RD /s /q "%sd%:\atmosphere\contents\010000000000100D")
if exist "%sd%:\atmosphere\contents\0100000000001000" (RD /s /q "%sd%:\atmosphere\contents\0100000000001000")
if exist "%sd%:\atmosphere\contents\0100000000001013" (RD /s /q "%sd%:\atmosphere\contents\0100000000001013")

if exist "%sd%:\atmosphere\contents\0000000000534C56" (RD /s /q "%sd%:\atmosphere\contents\0000000000534C56")
if exist "%sd%:\atmosphere\contents\00FF0000000002AA" (RD /s /q "%sd%:\atmosphere\contents\00FF0000000002AA")
if exist "%sd%:\atmosphere\contents\00FF0000636C6BF2" (RD /s /q "%sd%:\atmosphere\contents\00FF0000636C6BF2")
if exist "%sd%:\atmosphere\contents\00FF0000636C6BFF" (RD /s /q "%sd%:\atmosphere\contents\00FF0000636C6BFF")
if exist "%sd%:\atmosphere\contents\00FF00006D7470FF" (RD /s /q "%sd%:\atmosphere\contents\00FF00006D7470FF")
if exist "%sd%:\atmosphere\contents\00FF0000A53BB665" (RD /s /q "%sd%:\atmosphere\contents\00FF0000A53BB665")
if exist "%sd%:\atmosphere\contents\00FF0012656180FF" (RD /s /q "%sd%:\atmosphere\contents\00FF0012656180FF")
if exist "%sd%:\atmosphere\contents\01FF415446660000" (RD /s /q "%sd%:\atmosphere\contents\01FF415446660000")
if exist "%sd%:\atmosphere\contents\00FF747765616BFF" (RD /s /q "%sd%:\atmosphere\contents\00FF747765616BFF")
if exist "%sd%:\atmosphere\contents\0100000000000052" (RD /s /q "%sd%:\atmosphere\contents\0100000000000052")
if exist "%sd%:\atmosphere\contents\0100000000000081" (RD /s /q "%sd%:\atmosphere\contents\0100000000000081")
if exist "%sd%:\atmosphere\contents\0100000000000352" (RD /s /q "%sd%:\atmosphere\contents\0100000000000352")
if exist "%sd%:\atmosphere\contents\0100000000000464" (RD /s /q "%sd%:\atmosphere\contents\0100000000000464")
if exist "%sd%:\atmosphere\contents\0100000000000523" (RD /s /q "%sd%:\atmosphere\contents\0100000000000523")
if exist "%sd%:\atmosphere\contents\0100000000000901" (RD /s /q "%sd%:\atmosphere\contents\0100000000000901")
if exist "%sd%:\atmosphere\contents\0100000000000BED" (RD /s /q "%sd%:\atmosphere\contents\0100000000000BED")
if exist "%sd%:\atmosphere\contents\0100000000000BEF" (RD /s /q "%sd%:\atmosphere\contents\0100000000000BEF")
if exist "%sd%:\atmosphere\contents\0100000000000DAD" (RD /s /q "%sd%:\atmosphere\contents\0100000000000DAD")
if exist "%sd%:\atmosphere\contents\0100000000000F12" (RD /s /q "%sd%:\atmosphere\contents\0100000000000F12")
if exist "%sd%:\atmosphere\contents\0100000000000FAF" (RD /s /q "%sd%:\atmosphere\contents\0100000000000FAF")
if exist "%sd%:\atmosphere\contents\0100000000006480" (RD /s /q "%sd%:\atmosphere\contents\0100000000006480")
if exist "%sd%:\atmosphere\contents\0100000000007200" (RD /s /q "%sd%:\atmosphere\contents\0100000000007200")
if exist "%sd%:\atmosphere\contents\010000000000bd00" (RD /s /q "%sd%:\atmosphere\contents\010000000000bd00")
if exist "%sd%:\atmosphere\contents\010000000000C235" (RD /s /q "%sd%:\atmosphere\contents\010000000000C235")
if exist "%sd%:\atmosphere\contents\010000000000f00f" (RD /s /q "%sd%:\atmosphere\contents\010000000000f00f")
if exist "%sd%:\atmosphere\contents\010000000000FFAB" (RD /s /q "%sd%:\atmosphere\contents\010000000000FFAB")
if exist "%sd%:\atmosphere\contents\01000000001ED1ED" (RD /s /q "%sd%:\atmosphere\contents\01000000001ED1ED")
if exist "%sd%:\atmosphere\contents\0532232232232000" (RD /s /q "%sd%:\atmosphere\contents\0532232232232000")
if exist "%sd%:\atmosphere\contents\054e4f4558454000" (RD /s /q "%sd%:\atmosphere\contents\054e4f4558454000")
if exist "%sd%:\atmosphere\contents\2200000000000100" (RD /s /q "%sd%:\atmosphere\contents\2200000000000100")
if exist "%sd%:\atmosphere\contents\4100000000000324" (RD /s /q "%sd%:\atmosphere\contents\4100000000000324")
if exist "%sd%:\atmosphere\contents\4200000000000000" (RD /s /q "%sd%:\atmosphere\contents\4200000000000000")
if exist "%sd%:\atmosphere\contents\420000000000000E" (RD /s /q "%sd%:\atmosphere\contents\420000000000000E")
if exist "%sd%:\atmosphere\contents\420000000000000F" (RD /s /q "%sd%:\atmosphere\contents\420000000000000F")
if exist "%sd%:\atmosphere\contents\4200000000000010" (RD /s /q "%sd%:\atmosphere\contents\4200000000000010")
if exist "%sd%:\atmosphere\contents\4200000000000811" (RD /s /q "%sd%:\atmosphere\contents\4200000000000811")
if exist "%sd%:\atmosphere\contents\4200000000000BA6" (RD /s /q "%sd%:\atmosphere\contents\4200000000000BA6")
if exist "%sd%:\atmosphere\contents\4200000000000FFF" (RD /s /q "%sd%:\atmosphere\contents\4200000000000FFF")
if exist "%sd%:\atmosphere\contents\010000000007E51A" (RD /s /q "%sd%:\atmosphere\contents\010000000007E51A")
if exist "%sd%:\atmosphere\contents\420000000007E51A" (RD /s /q "%sd%:\atmosphere\contents\420000000007E51A")
if exist "%sd%:\atmosphere\contents\4200000000474442" (RD /s /q "%sd%:\atmosphere\contents\4200000000474442")
if exist "%sd%:\atmosphere\contents\4200000000696969" (RD /s /q "%sd%:\atmosphere\contents\4200000000696969")
if exist "%sd%:\atmosphere\contents\4200000AF1E8DA89" (RD /s /q "%sd%:\atmosphere\contents\4200000AF1E8DA89")
if exist "%sd%:\atmosphere\contents\42000062616B6101" (RD /s /q "%sd%:\atmosphere\contents\42000062616B6101")
if exist "%sd%:\atmosphere\contents\4200736372697074" (RD /s /q "%sd%:\atmosphere\contents\4200736372697074")
if exist "%sd%:\atmosphere\contents\4206900000000012" (RD /s /q "%sd%:\atmosphere\contents\4206900000000012")
if exist "%sd%:\atmosphere\contents\430000000000000A" (RD /s /q "%sd%:\atmosphere\contents\430000000000000A")
if exist "%sd%:\atmosphere\contents\430000000000000B" (RD /s /q "%sd%:\atmosphere\contents\430000000000000B")
if exist "%sd%:\atmosphere\contents\430000000000000C" (RD /s /q "%sd%:\atmosphere\contents\430000000000000C")
if exist "%sd%:\atmosphere\contents\43000000000000FF" (RD /s /q "%sd%:\atmosphere\contents\43000000000000FF")
if exist "%sd%:\atmosphere\contents\4300000000000909" (RD /s /q "%sd%:\atmosphere\contents\4300000000000909")
if exist "%sd%:\atmosphere\contents\5600000000000000" (RD /s /q "%sd%:\atmosphere\contents\5600000000000000")
if exist "%sd%:\atmosphere\contents\690000000000000D" (RD /s /q "%sd%:\atmosphere\contents\690000000000000D")

REM ======= BOOTLOADER ORDNER ======================================================
if exist "%sd%:\bootloader\sys" (RD /s /q "%sd%:\bootloader\sys")
if exist "%sd%:\bootloader\payloads\hekate_ctcaer_*.bin" (del "%sd%:\bootloader\payloads\hekate_ctcaer_*.bin")
if exist "%sd%:\bootloader\payloads\Incognito*.bin" (del "%sd%:\bootloader\payloads\Incognito*.bin")
if exist "%sd%:\bootloader\ini\!kefir_updater.ini" (del "%sd%:\bootloader\ini\!kefir_updater.ini")
if exist "%sd%:\bootloader\ini\kefir_updater.ini" (del "%sd%:\bootloader\ini\kefir_updater.ini")
if exist "%sd%:\bootloader\ini\fullstock.ini" (del "%sd%:\bootloader\ini\fullstock.ini")
if exist "%sd%:\bootloader\bootlogo.bmp" (del "%sd%:\bootloader\bootlogo.bmp")
if exist "%sd%:\bootloader\bootlogo_kefir.bmp" (del "%sd%:\bootloader\bootlogo_kefir.bmp")
if exist "%sd%:\bootloader\updating.bmp" (del "%sd%:\bootloader\updating.bmp")
if exist "%sd%:\bootloader\hekate_ipl.ini" (del "%sd%:\bootloader\")
if exist "%sd%:\bootloader\hekate_ipl_.ini" (del "%sd%:\bootloader\")
if exist "%sd%:\bootloader\nyx.ini" (del "%sd%:\bootloader\nyx.ini")
if exist "%sd%:\bootloader\nyx.ini_" (del "%sd%:\bootloader\nyx.ini")
if exist "%sd%:\bootloader\patches.ini" (del "%sd%:\bootloader\patches.ini")
if exist "%sd%:\bootloader\update.bin" (del "%sd%:\bootloader\update.bin")

REM ======= CONFIG ORDNER ==========================================================
if exist "%sd%:\config\amsPACK-Downloader" (RD /s /q "%sd%:\config\amsPACK-Downloader")
if exist "%sd%:\config\sys-ftpd" (RD /s /q "%sd%:\config\sys-ftpd")
if exist "%sd%:\config\aio-switch-updater" (RD /s /q "%sd%:\config\\aio-switch-updater")
if exist "%sd%:\config\btred" (RD /s /q "%sd%:\config\btred")
if exist "%sd%:\config\reinx-spoofer" (RD /s /q "%sd%:\config\reinx-spoofer")
if exist "%sd%:\config\ShallowSea-updater" (RD /s /q "%sd%:\config\ShallowSea-updater")
if exist "%sd%:\config\kefir-updater" (RD /s /q "%sd%:\config\kefir-updater")
if exist "%sd%:\config\kefir-helper" (RD /s /q "%sd%:\config\kefir-helper")

REM ======= SD-KARTEN ROOT =========================================================
if exist "%sd%:\modules" (RD /s /q "%sd%:\modules")
if exist "%sd%:\NSPs" (RD /s /q "%sd%:\NSPs")
if exist "%sd%:\firmware*" (RD /s /q "%sd%:\firmware*")
if exist "%sd%:\Custom*" (RD /s /q "%sd%:\Custom*")
if exist "%sd%:\SaltySD" (RD /s /q "%sd%:\SaltySD")
if exist "%sd%:\atmo" (RD /s /q "%sd%:\atmo")
if exist "%sd%:\ams" (RD /s /q "%sd%:\ams")
if exist "%sd%:\scripts" (RD /s /q "%sd%:\scripts")
if exist "%sd%:\music" (RD /s /q "%sd%:\music")
if exist "%sd%:\tools*" (RD /s /q "%sd%:\tools*")
if exist "%sd%:\games" (RD /s /q "%sd%:\games")
if exist "%sd%:\pegascape" (RD /s /q "%sd%:\pegascape")
if exist "%sd%:\TinGen" (RD /s /q "%sd%:\TinGen")
if exist "%sd%:\sept" (RD /s /q  "%sd%:\sept")
if exist "%sd%:\.git" (RD /s /q "%sd%:\.git")
if exist "%sd%:\hbmenu.nro" (del "%sd%:\hbmenu.nro")
if exist "%sd%:\startup.te" (del "%sd%:\startup.te")
if exist "%sd%:\*.ini" (del "%sd%:\*.ini")
if exist "%sd%:\*.bin" (del "%sd%:\*.bin")
if exist "%sd%:\*.txt" (del "%sd%:\*.txt")
if exist "%sd%:\*.dat" (del "%sd%:\*.dat")
if exist "%sd%:\*.log" (del "%sd%:\*.log")
if exist "%sd%:\sxos*" (RD /s /q  "%sd%:\sxos*")

REM ======= SWITCH ORDNER ==========================================================
if exist "%sd%:\switch\amsPack*" (RD /s /q "%sd%:\switch\amsPack*")
if exist "%sd%:\switch\DeepSea*" (RD /s /q "%sd%:\switch\DeepSea*")
if exist "%sd%:\switch\ShallowSea*" (RD /s /q "%sd%:\switch\ShallowSea*")
if exist "%sd%:\switch\tinwoo*" (RD /s /q "%sd%:\switch\tinwoo*")
if exist "%sd%:\switch\tinleaf*" (RD /s /q "%sd%:\switch\tinleaf*")
if exist "%sd%:\switch\daybreak*" (RD /s /q "%sd%:\switch\daybreak*")
if exist "%sd%:\switch\kefir*" (RD /s /q "%sd%:\switch\kefir*")
if exist "%sd%:\switch\download*" (RD /s /q "%sd%:\switch\download*")
if exist "%sd%:\switch\updater*" (RD /s /q "%sd%:\switch\updater*")
if exist "%sd%:\switch\switch-time" (RD /s /q "%sd%:\switch\switch-time")
if exist "%sd%:\switch\NXMPforMe" (RD /s /q "%sd%:\switch\NXMPforMe")
if exist "%sd%:\switch\lithium" (RD /s /q "%sd%:\switch\lithium")
if exist "%sd%:\switch\LinkUser" (RD /s /q "%sd%:\switch\LinkUser")
if exist "%sd%:\switch\TriPlayer" (RD /s /q "%sd%:\switch\TriPlayer")
if exist "%sd%:\switch\KosmosToolbox" (RD /s /q "%sd%:\switch\KosmosToolbox")
if exist "%sd%:\switch\mercury" (RD /s /q "%sd%:\switch\mercury")
if exist "%sd%:\switch\Fizeau" (RD /s /q "%sd%:\switch\Fizeau\")
if exist "%sd%:\switch\FreshHay" (RD /s /q "%sd%:\switch\FreshHay\")
if exist "%sd%:\switch\nx-ntpc" (RD /s /q "%sd%:\switch\nx-ntpc\")
if exist "%sd%:\switch\incognito" (RD /s /q "%sd%:\switch\incognito")
if exist "%sd%:\switch\fakenews-injector" (RD /s /q "%sd%:\switch\fakenews-injector")
if exist "%sd%:\switch\ChoiDujourNX" (RD /s /q "%sd%:\switch\ChoiDujourNX")
if exist "%sd%:\switch\Reboot_to_Payload" (RD /s /q "%sd%:\switch\Reboot_to_Payload")
if exist "%sd%:\switch\pplay" (RD /s /q "%sd%:\switch\pplay")
if exist "%sd%:\switch\SX*" (RD /s /q "%sd%:\switch\SX*")
if exist "%sd%:\switch\tinfoil" (RD /s /q "%sd%:\switch\tinfoil")
if exist "%sd%:\switch\.overlays" (RD /s /q "%sd%:\switch\.overlays")
if exist "%sd%:\switch\*.nro" (del "%sd%:\switch\*.nro")
if exist "%sd%:\switch\*.ini" (del "%sd%:\switch\*.ini")
if exist "%sd%:\switch\*.jar" (del "%sd%:\switch\*.jar")
if exist "%sd%:\switch\*.zip" (del "%sd%:\switch\*.zip")
if exist "%sd%:\switch\*.star" (del "%sd%:\switch\*.star")
if exist "%sd%:\switch\dbi\dbi.nro" (del "%sd%:\switch\dbi\dbi.nro")
if exist "%sd%:\switch\dbi\dbi.config" (del "%sd%:\switch\dbi\dbi.config")

REM ================================================================================
:sblegtlos
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo   Jetzt wird das satanarchaeoluegenialkohoellische Switch Bros. Paket              
echo                  direkt auf deine SD-Karte geballert!         
echo.
echo                    Du verdienst halt nur das BESTE!      
echo.
echo.
echo         Druecke die Eingabetaste und loese dich von der Matrix!
echo.
echo --------------------------------------------------------------------------------
pause>nul 2>&1

xcopy "%~dp0*" "%sd%:\" /H /Y /C /R /S /E

REM ================================================================================
:systempartitionen
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Waehle die hekate Systeme aus, die dir spaeter in hekate zur
echo     Verfuegung stehen sollen!
echo.
echo     Entweder sind die Systeme bereits bei dir installiert, oder du
echo     moechtest diese spaeter installieren = Die Partitionen dafuer
echo     nicht vergessen (Partiton nachtraeglich geht nicht)!
echo.
echo --------------------------------------------------------------------------------
echo     Achtung modchip Besitzer = LAKKA und Ubuntu Bionic
echo                                werden jetzt unterstuetzt!
echo.
echo     Android und die anderen Linux Distributionen z.Zt. NICHT!!!
echo --------------------------------------------------------------------------------
echo.
echo 0 = alte hekate_ipl.ini behalten (nicht empfohlen)
echo 1 = Basis (Standard)
echo 2 = Basis + Android
echo 3 = Basis + Linux
echo 4 = Basis + LAKKA
echo 5 = Basis + Android + Linux
echo 6 = Basis + Android + LAKKA
echo 7 = Basis + Android + Linux + LAKKA
echo 8 = Basis + Linux + LAKKA
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p eingabe="Deine Systemkombination: "
if /i "%eingabe%"=="0" GOTO altesystembehalten
if /i "%eingabe%"=="1" GOTO nurbasissystem
if /i "%eingabe%"=="2" GOTO androidpartition
if /i "%eingabe%"=="3" GOTO linuxpartition
if /i "%eingabe%"=="4" GOTO lakkapartition
if /i "%eingabe%"=="5" GOTO androidlinux
if /i "%eingabe%"=="6" GOTO androidlakka
if /i "%eingabe%"=="7" GOTO androidlinuxlakka
if /i "%eingabe%"=="8" GOTO linuxlakka
if /i "%eingabe%"=="H" GOTO hauptmenue

REM ================================================================================
:altesystembehalten
if exist "%sd%:\switchbros\backup\nyx.ini" (xcopy "%sd%:\switchbros\backup\nyx.ini" "%sd%:\bootloader\nyx.ini" /H /Y /C /R /S /E /I)
if exist "%sd%:\switchbros\backup\hekate_ipl.ini" (xcopy "%sd%:\switchbros\backup\hekate_ipl.ini" "%sd%:\bootloader\hekate_ipl.ini" /H /Y /C /R /S /E /I)
if exist "%sd%:\switchbros\backup\fastcfwswitch\config.ini" (xcopy "%sd%:\switchbros\backup\fastcfwswitch\config.ini" "%sd%:\config\fastCFWSwitch\*" /H /Y /C /R /S /E /I)
GOTO kindgerecht

REM ================================================================================
:nurbasissystem
xcopy "%sd%:\switchbros\system\b\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:androidpartition
xcopy "%sd%:\switchbros\system\ba\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:linuxpartition
echo --------------------------------------------------------------------------------
echo.
echo Welche der vier Linux Distributionen wirst du sp+�ter nutzen?
echo.
echo A = Arch Linux
echo B = Ubuntu Bionic (empfohlen, wenn unsicher (L4T fuer modchip))
echo C = Fedora Linux
echo D = Ubuntu
echo.
echo --------------------------------------------------------------------------------
echo.
set "Linux="
set /p Linux=Waehle deine Linux Distribution: 
if /i "%Linux%"=="A" xcopy "%sd%:\switchbros\system\bu\arch\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="B" xcopy "%sd%:\switchbros\system\bu\bionic\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="C" xcopy "%sd%:\switchbros\system\bu\fedora\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="D" xcopy "%sd%:\switchbros\system\bu\ubuntu\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:lakkapartition
xcopy "%sd%:\switchbros\system\bl\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:androidlinux
echo --------------------------------------------------------------------------------
echo.
echo Welche der vier Linux Distributionen wirst du sp+�ter nutzen?
echo.
echo A = Arch Linux
echo B = Ubuntu Bionic (empfohlen, wenn unsicher (L4T fuer modchip))
echo C = Fedora Linux
echo D = Ubuntu
echo.
echo --------------------------------------------------------------------------------
echo.
set "Linux="
set /p Linux=Waehle deine Linux Distribution: 
if /i "%Linux%"=="A" xcopy "%sd%:\switchbros\system\bau\arch\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="B" xcopy "%sd%:\switchbros\system\bau\bionic\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="C" xcopy "%sd%:\switchbros\system\bau\fedora\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="D" xcopy "%sd%:\switchbros\system\bau\ubuntu\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:androidlakka
xcopy "%sd%:\switchbros\system\bal\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:androidlinuxlakka
echo --------------------------------------------------------------------------------
echo.
echo Welche der vier Linux Distributionen wirst du sp+�ter nutzen?
echo.
echo A = Arch Linux
echo B = Ubuntu Bionic (empfohlen, wenn unsicher (L4T fuer modchip))
echo C = Fedora Linux
echo D = Ubuntu
echo.
echo --------------------------------------------------------------------------------
echo.
set "Linux="
set /p Linux=Waehle deine Linux Distribution: 
if /i "%Linux%"=="A" xcopy "%sd%:\switchbros\system\balu\arch\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="B" xcopy "%sd%:\switchbros\system\balu\bionic\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="C" xcopy "%sd%:\switchbros\system\balu\fedora\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="D" xcopy "%sd%:\switchbros\system\balu\ubuntu\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:linuxlakka
echo --------------------------------------------------------------------------------
echo.
echo Welche der vier Linux Distributionen wirst du sp+�ter nutzen?
echo.
echo A = Arch Linux
echo B = Ubuntu Bionic (empfohlen, wenn unsicher (L4T fuer modchip))
echo C = Fedora Linux
echo D = Ubuntu
echo.
echo --------------------------------------------------------------------------------
echo.
set "Linux="
set /p Linux=Waehle deine Linux Distribution: 
if /i "%Linux%"=="A" xcopy "%sd%:\switchbros\system\blu\arch\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="B" xcopy "%sd%:\switchbros\system\blu\bionic\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="C" xcopy "%sd%:\switchbros\system\blu\fedora\*" "%sd%:\" /H /Y /C /R /S /E /I
if /i "%Linux%"=="D" xcopy "%sd%:\switchbros\system\blu\ubuntu\*" "%sd%:\" /H /Y /C /R /S /E /I
GOTO kindgerecht

REM ================================================================================
:kindgerecht
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Solltest du Kinder haben, und NICHT wollen das die App = Tinfoil 
echo     auf dem homescreen erscheint (empfohlen), dann kannst du hier
echo     auswaehlen welche Version von Tinfoil installiert werden soll!
echo.
echo     1 = Tinfoil im hbmenu (nicht neben anderen Spielen auf dem homescreen)
echo.
echo     2 = Tinfoil auf dem homescreen (aktualisiert sich spaeter selbst)
echo.
echo     W = Kein Tinfoil (Spiele manuell holen und installieren, zb mit DBI)
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p kindgerecht=Waehle deine Tinfoil Version: 
	if /i "%kindgerecht%"=="1" GOTO tinfoila
	if /i "%kindgerecht%"=="2" GOTO tinfoilb
	if /i "%kindgerecht%"=="W" GOTO tinfoilno
	if /i "%kindgerecht%"=="H" GOTO hauptmenue

:tinfoila
xcopy "%sd%:\switchbros\kids\switch\*" "%sd%:\switch\*" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\kids\tinfoilhbmenu\*" "%sd%:\" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\kids\NSPs\*" "%sd%:\NSPs\" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\backup\Tinfoil\locations.conf" "%sd%:\switch\tinfoil\*" /H /Y /C /R /S /E /I
GOTO themepaket

:tinfoilb
xcopy "%sd%:\switchbros\kids\switch\*" "%sd%:\switch\" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\kids\tinfoilhomescreen\*" "%sd%:\" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\kids\NSPs\*" "%sd%:\NSPs\" /H /Y /C /R /S /E /I
xcopy "%sd%:\switchbros\backup\Tinfoil\locations.conf" "%sd%:\switch\tinfoil\" /H /Y /C /R /S /E /I
GOTO themepaket

:tinfoilno
RD /s /q "%sd%:\switch\tinfoil"
del "%sd%:\NSPs\Tinfoil [050000BADDAD0000][15.0][v0].nsp"
GOTO themepaket

REM ================================================================================
:themepaket
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Hier kannst du unser SwitchBros_ThemeApps-Paket installieren lassen! 
echo                       (Geht auch spaeter manuell) 
echo.
echo     Das ThemeApps_Paket besteht aus folgenden Apps: 
echo.
echo     NX-ThemeInstaller = Theme-System einrichten und Themes installieren! 
echo     ThemezerNX = mehr als 1000 Themes suchen und downloaden! 
echo     Icongrabber = Verbinde dich ueber die steamgriddb.com Seite und
echo                   hole dir dein Lieblings-Icon (Steam API wird benoetigt)! 
echo     sys-tweak = Wird fuer Vertikale und horzontale Icons benoetigt! 
echo.
echo     1 = ThemeApps_Paket installieren!
echo.
echo     2 = ThemeApps_Paket deinstallieren!
echo.
echo     W = Ueberspringen und im Skript weiter gehen!
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p themepaket=Sollen die ThemeApps installiert werden: 
	if /i "%themepaket%"=="1" GOTO themepaketinst
	if /i "%themepaket%"=="2" GOTO themepaketdeinst
	if /i "%themepaket%"=="W" GOTO systemmodule
	if /i "%themepaket%"=="H" GOTO hauptmenue

REM ================================================================================
:themepaketinst
xcopy "%sd%:\switchbros\theme\*" "%sd%:\" /H /Y /C /R /S /E /I

REM ================================================================================
:themepaketdeinst
xcopy "%sd%:\switchbros\theme\*" "%sd%:\" /H /Y /C /R /S /E /I

REM ================================================================================
:systemmodule
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Das Tesla Overlay Menue wird aufgerufen mit: 
echo.
echo                          ZL + ZR + PLUS Taste 
echo.
echo     1 = Tesla-Overlay mit allen Modulen (nicht empfohlen)!
echo     2 = Tesla-Overlay mit Standard SwitchBros Modulen (empfohlen wenn unsicher)!
echo     3 = Tesla-Overlay mit einzeln ausgewaehlten Modulen (empfohlen)!
echo.
echo     W = Ueberspringen und im Skript weiter gehen!
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p sysmod=Welches Tesla-Overlay soll installiert werden?: 
	if /i "%sysmod%"=="1" GOTO teslakomplett
	if /i "%sysmod%"=="2" GOTO teslaminimal
	if /i "%sysmod%"=="3" GOTO teslamodintro
	if /i "%sysmod%"=="W" GOTO attributeundmac
	if /i "%sysmod%"=="H" GOTO hauptmenue

REM ================================================================================
:teslakomplett
	xcopy "%sd%:\switchbros\sys-modul\Tesla-menu\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\BootSoundNX\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\EdiZon\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\emuiibo\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\fastcfwswitch\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\Fizeau\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\ldnmitm\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\MissionControl\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\ovlSysmodule\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\Status-Monitor-Overlay\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-clk\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-clk-Editor\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-con\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sysdvr-overlay\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO attributeundmac

REM ================================================================================
:teslaminimal
	xcopy "%sd%:\switchbros\sys-modul\Tesla-menu\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\fastcfwswitch\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\MissionControl\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\ovlSysmodule\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\Status-Monitor-Overlay\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-clk\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-clk-Editor\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\sys-modul\sys-con\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO attributeundmac

REM ================================================================================
:teslamodintro
COLOR 0E
xcopy "%sd%:\switchbros\sys-modul\Tesla-menu\*" "%sd%:\" /H /Y /C /R /S /E /I

REM ================================================================================
:teslamodular
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Waehle hier die Module die du im Tesla-Overlay haben moechtest! 
echo     Das Tesla-Overlay wurde hier bereits installiert! 
echo.
echo     Erst wenn du auf 'Weiter' gehst wird das Skript fortgesetzt! 
echo.
echo      1 = BootSoundNX (Bootsound beim Systemstart)
echo      2 = Edizon (Cheats nutzen)
echo      3 = emuiibo (damit kann man virtuelle amiibos nutzen)
echo      4 = fastCFWswitch (Launcher fuer Payloads (nicht fuer Modchip))
echo      5 = Fizeau (Bildschirmanzeige optimieren/verbessern)
echo      6 = ldn_mitm (LAN-Play App)
echo      7 = MissionControl (fremd Controller ueber Bluetooth)
echo      8 = ovlSysmodule (Tesla-Overlay module aktivieren/deaktivieren)
echo      9 = Status-Monitor-Overlay (Werte der Switch an anzeigen)
echo     10 = sys-clk (Switch Uebertakten/Untertakten)
echo     11 = sys-clk-Editor (Werte in die config.ini von sys-clk eintragen)
echo     12 = sys-con (fremd Controller ueber USB)
echo     13 = SysDVR-Overlay (Switch Bildschirm auf den PC uebertragen)
echo.
echo      W = Ueberspringen und im Skript weiter gehen!
echo.
echo --------------------------------------------------------------------------------
echo      H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set "teslamods="
set /p teslamods=Welche Tesla-Overlay Module sollen installiert werden?: 
	if /i "%teslamods%"=="1" GOTO bootsoundnx
	if /i "%teslamods%"=="2" GOTO edizon
	if /i "%teslamods%"=="3" GOTO emuiibo
	if /i "%teslamods%"=="4" GOTO fastcfwswitch
	if /i "%teslamods%"=="5" GOTO fizeau
	if /i "%teslamods%"=="6" GOTO ldnmitm
	if /i "%teslamods%"=="7" GOTO missioncontrol
	if /i "%teslamods%"=="8" GOTO ovlssysmodule
	if /i "%teslamods%"=="9" GOTO statmon
	if /i "%teslamods%"=="10" GOTO sysclk
	if /i "%teslamods%"=="11" GOTO sysclkedit
	if /i "%teslamods%"=="12" GOTO syscon
	if /i "%teslamods%"=="13" GOTO sysdvr
	if /i "%teslamods%"=="W" GOTO attributeundmac
	if /i "%teslamods%"=="H" GOTO hauptmenue

REM ================================================================================
:bootsoundnx
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll BootSoundNX installiert oder deinstalliert werden?
echo.
echo    1 = BootSoundNX installieren
echo    2 = BootSoundNX deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "bootsoundnx="
set /p bootsoundnx=Bitte triff deine Auswahl: 
	if /i "%bootsoundnx%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\BootSoundNX\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%bootsoundnx%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\00FF0000000002AA"
	RD /s /q "%sd%:\config\BootSoundNX"
	GOTO teslamodular
	)
	if /i "%bootsoundnx%"=="3" GOTO teslamodular

REM ================================================================================
:edizon
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll EdiZon installiert oder deinstalliert werden?
echo.
echo    1 = EdiZon installieren
echo    2 = EdiZon deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "edizon="
set /p edizon=Bitte triff deine Auswahl: 
	if /i "%edizon%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\EdiZon\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%edizon%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\054e4f4558454000"
	RD /s /q "%sd%:\atmosphere\contents\010000000000000D"
	RD /s /q "%sd%:\atmosphere\contents\0100000000001013"
	RD /s /q "%sd%:\switch\EdiZon"
	RD /s /q "%sd%:\switch\breeze"
	RD /s /q "%sd%:\switch\appstore\.get\packages\EdiZon"
	del "%sd%:\switch\.overlays\4_ovlEdiZon.ovl"
	GOTO teslamodular
	)
	if /i "%edizon%"=="3" GOTO teslamodular

REM ================================================================================
:emuiibo
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll emuiibo installiert oder deinstalliert werden?
echo.
echo    1 = emuiibo installieren
echo    2 = emuiibo deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "emuiibo="
set /p emuiibo=Bitte triff deine Auswahl: 
	if /i "%emuiibo%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\emuiibo\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%emuiibo%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\0100000000000352"
	RD /s /q "%sd%:\emuiibo"
	RD /s /q "%sd%:\switch\appstore\.get\packages\emuiibo"
	del "%sd%:\switch\.overlays\2_emuiibo.ovl"
	GOTO teslamodular
	)
	if /i "%emuiibo%"=="3" GOTO teslamodular

REM ================================================================================
:fastcfwswitch
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll emuiibo installiert oder deinstalliert werden?
echo.
echo    1 = emuiibo installieren
echo    2 = emuiibo deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "fastcfwswitch="
set /p fastcfwswitch=Bitte triff deine Auswahl: 
	if /i "%fastcfwswitch%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\fastCFWSwitch\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%fastcfwswitch%"=="2" (
	RD /s /q "%sd%:\config\fastCFWSwitch"
	RD /s /q "%sd%:\switch\appstore\.get\packages\fastCFWSwitch"
	del "%sd%:\switch\.overlays\0_fastCFWswitch.ovl"
	GOTO teslamodular
	)
	if /i "%fastcfwswitch%"=="3" GOTO teslamodular

REM ================================================================================
:fizeau
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll Fizeau installiert oder deinstalliert werden?
echo.
echo    1 = Fizeau installieren
echo    2 = Fizeau deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "fizeau="
set /p fizeau=Bitte triff deine Auswahl: 
	if /i "%fizeau%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\Fizeau\*" "%sd%:\" /H /Y /C /R /S /E /I
	xcopy "%sd%:\switchbros\backup\Fizeau\config.ini" "%sd%:\config\Fizeau\config.ini" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%fizeau%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\0100000000000F12"
	RD /s /q "%sd%:\config\Fizeau"
	RD /s /q "%sd%:\switch\Fizeau"
	RD /s /q "%sd%:\switch\appstore\.get\packages\Fizeau"
	del "%sd%:\switch\.overlays\5_Fizeau.ovl"
	GOTO teslamodular
	)
	if /i "%fizeau%"=="3" GOTO teslamodular

REM ================================================================================
:ldnmitm
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll ldnmitm installiert oder deinstalliert werden?
echo.
echo    1 = ldnmitm installieren
echo    2 = ldnmitm deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "ldnmitm="
set /p ldnmitm=Bitte triff deine Auswahl: 
	if /i "%ldnmitm%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\ldnmitm\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%ldnmitm%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\4200000000000010"
	RD /s /q "%sd%:\switch\ldn_mitm_config"
	RD /s /q "%sd%:\switch\appstore\.get\packages\ldn_mitm_config"
	del "%sd%:\switch\.overlays\1_ldnmitm_config"
	GOTO teslamodular
	)
	if /i "%ldnmitm%"=="3" GOTO teslamodular

REM ================================================================================
:missioncontrol
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll MissionControl installiert oder deinstalliert werden?
echo.
echo    1 = MissionControl installieren
echo    2 = MissionControl deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "missioncontrol="
set /p missioncontrol=Bitte triff deine Auswahl: 
	if /i "%missioncontrol%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\MissionControl\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%missioncontrol%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\010000000000bd00"
	RD /s /q "%sd%:\atmosphere\contents\exefs_patches\bluetooth_patches"
	RD /s /q "%sd%:\config\MissionControl"
	RD /s /q "%sd%:\switch\appstore\.get\packages\missioncontrol"
	GOTO teslamodular
	)
	if /i "%missioncontrol%"=="3" GOTO teslamodular

REM ================================================================================
:ovlssysmodule
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll ovl-Sysmodul installiert oder deinstalliert werden?
echo.
echo    1 = ovl-Sysmodul installieren
echo    2 = ovl-Sysmodul deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "ovlssysmodule="
set /p ovlssysmodule=Bitte triff deine Auswahl: 
	if /i "%ovlssysmodule%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\ovlSysmodule\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%ovlssysmodule%"=="2" (
	RD /s /q "%sd%:\switch\appstore\.get\packages\ovlssysmodule"
	del "%sd%:\switch\.overlays\7_ovlSysmodules.ovl"
	GOTO teslamodular
	)
	if /i "%ovlssysmodule%"=="3" GOTO teslamodular

REM ================================================================================
:statmon
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll Status-Monitor-Overlay installiert oder deinstalliert werden?
echo.
echo    1 = Status-Monitor-Overlay installieren
echo    2 = Status-Monitor-Overlay deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "statmon="
set /p statmon=Bitte triff deine Auswahl: 
	if /i "%statmon%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\Status-Monitor-Overlay\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%statmon%"=="2" (
	RD /s /q "%sd%:\switch\appstore\.get\packages\Status-Monitor-Overlay"
	del "%sd%:\switch\.overlays\8_Status-Monitor-Overlay.ovl"
	GOTO teslamodular
	)
	if /i "%statmon%"=="3" GOTO teslamodular

REM ================================================================================
:sysclk
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll sys-clk installiert oder deinstalliert werden?
echo.
echo    1 = sys-clk installieren
echo    2 = sys-clk deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "sysclk="
set /p sysclk=Bitte triff deine Auswahl: 
	if /i "%sysclk%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\sys-clk\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%sysclk%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\00FF0000636C6BFF"
	RD /s /q "%sd%:\config\sys-clk"
	RD /s /q "%sd%:\switch\.overlays\3_sys-clk-overlay"
	RD /s /q "%sd%:\switch\appstore\.get\packages\sys-clk-manager"
	RD /s /q "%sd%:\switch\sys-clk-manager"
	GOTO teslamodular
	)
	if /i "%sysclk%"=="3" GOTO teslamodular

REM ================================================================================
:sysclkedit
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll sys-clk-Editor installiert oder deinstalliert werden?
echo.
echo    1 = sys-clk-Editor installieren
echo    2 = sys-clk-Editor deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "sysclkedit="
set /p sysclkedit=Bitte triff deine Auswahl: 
	if /i "%sysclkedit%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\sys-clk-Editor\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%sysclkedit%"=="2" (
	RD /s /q "%sd%:\switch\appstore\.get\packages\sys-clk-Editor"
	RD /s /q "%sd%:\switch\sys-clk-Editor"
	GOTO teslamodular
	)
	if /i "%sysclkedit%"=="3" GOTO teslamodular

REM ================================================================================
:syscon
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll sys-con installiert oder deinstalliert werden?
echo.
echo    1 = sys-con installieren
echo    2 = sys-con deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "syscon="
set /p syscon=Bitte triff deine Auswahl: 
	if /i "%syscon%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\sys-con\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%syscon%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\690000000000000D"
	RD /s /q "%sd%:\config\sys-con"
	RD /s /q "%sd%:\switch\appstore\.get\packages\sys-con"
	GOTO teslamodular
	)
	if /i "%syscon%"=="3" GOTO teslamodular

REM ================================================================================
:sysdvr
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo    Soll sysDVR installiert oder deinstalliert werden?
echo.
echo    1 = sysDVR installieren
echo    2 = sysDVR deinstallieren
echo.
echo    T = Zurueck zum Tesla-Overlay Einzelmodul Menue!
echo --------------------------------------------------------------------------------
echo.

set "syscon="
set /p syscon=Bitte triff deine Auswahl: 
	if /i "%syscon%"=="1" (
	xcopy "%sd%:\switchbros\sys-modul\sysdvr-overlay\*" "%sd%:\" /H /Y /C /R /S /E /I
	GOTO teslamodular
	)
	if /i "%syscon%"=="2" (
	RD /s /q "%sd%:\atmosphere\contents\00FF0000A53BB665"
	RD /s /q "%sd%:\config\sysdvr"
	RD /s /q "%sd%:\switch\.overlays\6_sysdvr-overlay.ovl"
	RD /s /q "%sd%:\switch\appstore\.get\packages\SysDVR-conf"
	RD /s /q "%sd%:\switch\appstore\.get\packages\sysdvr-overlay"
	RD /s /q "%sd%:\switch\SysDVR-conf"
	GOTO teslamodular
	)
	if /i "%syscon%"=="3" GOTO teslamodular

REM ================================================================================
:zusatzapps

REM ================================================================================
:attributeundmac
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Attribute in Ordnung bringen und MacOS Dateien entfernen!
echo.
echo     1 = Attribute bereinigen (fixArchiveBit) und weiter im Skript!
echo.
echo.
echo     2 = Attribute bereinigen (fixArchiveBit) und zurueck zum Hauptmenue!
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p fixattrib=Welches Tesla-Overlay soll installiert werden?: 
	if /i "%fixattrib%"=="1" GOTO fixattribweiter
	if /i "%fixattrib%"=="2" GOTO fixattribhaupt
	if /i "%fixattrib%"=="H" GOTO hauptmenue

REM ================================================================================
:fixattribhaupt
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo                         Attribute werden korrigiert! 
echo                             (Fix archive bit) 
echo.
echo                    MacOS typische Dateien werden entfernt! 
echo.
echo                         Schreibschutz wird entfernt! 
echo.
echo       BITTE WARTEN...
echo.
echo --------------------------------------------------------------------------------
echo.

if exist "%sd%:\atmosphere" (
	attrib -A -R /S /D %sd%:\atmosphere\*
	attrib -A -R %sd%:\atmosphere)
if exist "%sd%:\atmosphere\contents" (
	attrib -A -R /S /D %sd%:\atmosphere\contents\*
	attrib -A -R %sd%:\atmosphere\contents)
if exist "%sd%:\bootloader" (
	attrib -A -R /S /D %sd%:\bootloader\*
	attrib -A -R %sd%:\bootloader)
if exist "%sd%:\config" (
	attrib -A -R /S /D %sd%:\config\*
	attrib -A -R %sd%:\config)
if exist "%sd%:\NSPs" (
	attrib -A -R /S /D %sd%:\NSPs\*
	attrib -A -R %sd%:\NSPs)
if exist "%sd%:\emuiibo" (
	attrib -A -R /S /D %sd%:\emuiibo\*
	attrib -A -R %sd%:\emuiibo)
if exist "%sd%:\switch" (
	attrib -A -R /S /D %sd%:\switch\*
	attrib -A -R %sd%:\switch)
if exist "%sd%:\tegraexplorer" (
	attrib -A -R /S /D %sd%:\tegraexplorer\*
	attrib -A -R %sd%:\tegraexplorer)
if exist "%sd%:\themes" (
	attrib -A -R /S /D %sd%:\themes\*
	attrib -A -R %sd%:\themes)
if exist "%sd%:\warmboot" (
	attrib -A -R /S /D %sd%:\warmboot\*
	attrib -A -R %sd%:\warmboot)
if exist "%sd%:\hbmenu.nro" (attrib -A -R %sd%:\hbmenu.nro)
if exist "%sd%:\boot.dat" (attrib -A -R %sd%:\boot.dat)
if exist "%sd%:\boot.ini" (attrib -A -R %sd%:\boot.ini)
if exist "%sd%:\payload.bin" (attrib -A -R %sd%:\payload.bin)
if exist "%sd%:\exosphere.ini" (attrib -A -R %sd%:\exosphere.ini)
rem Entfernen typischer MacOS Dateien (die sind ueberall die Bruedaz)
if exist .DS_STORE del /s /q /f /a .DS_STORE
if exist ._.* del /s /q /f /a ._.*
GOTO hauptmenue

REM ================================================================================
:fixattribweiter
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo                         Attribute werden korrigiert! 
echo                             (Fix archive bit) 
echo.
echo                    MacOS typische Dateien werden entfernt! 
echo.
echo                         Schreibschutz wird entfernt! 
echo.
echo       BITTE WARTEN...
echo.
echo --------------------------------------------------------------------------------
echo.

if exist "%sd%:\atmosphere" (
	attrib -A -R /S /D %sd%:\atmosphere\*
	attrib -A -R %sd%:\atmosphere)
if exist "%sd%:\atmosphere\contents" (
	attrib -A -R /S /D %sd%:\atmosphere\contents\*
	attrib -A -R %sd%:\atmosphere\contents)
if exist "%sd%:\bootloader" (
	attrib -A -R /S /D %sd%:\bootloader\*
	attrib -A -R %sd%:\bootloader)
if exist "%sd%:\config" (
	attrib -A -R /S /D %sd%:\config\*
	attrib -A -R %sd%:\config)
if exist "%sd%:\NSPs" (
	attrib -A -R /S /D %sd%:\NSPs\*
	attrib -A -R %sd%:\NSPs)
if exist "%sd%:\emuiibo" (
	attrib -A -R /S /D %sd%:\emuiibo\*
	attrib -A -R %sd%:\emuiibo)
if exist "%sd%:\switch" (
	attrib -A -R /S /D %sd%:\switch\*
	attrib -A -R %sd%:\switch)
if exist "%sd%:\tegraexplorer" (
	attrib -A -R /S /D %sd%:\tegraexplorer\*
	attrib -A -R %sd%:\tegraexplorer)
if exist "%sd%:\themes" (
	attrib -A -R /S /D %sd%:\themes\*
	attrib -A -R %sd%:\themes)
if exist "%sd%:\warmboot" (
	attrib -A -R /S /D %sd%:\warmboot\*
	attrib -A -R %sd%:\warmboot)
if exist "%sd%:\hbmenu.nro" (attrib -A -R %sd%:\hbmenu.nro)
if exist "%sd%:\boot.dat" (attrib -A -R %sd%:\boot.dat)
if exist "%sd%:\boot.ini" (attrib -A -R %sd%:\boot.ini)
if exist "%sd%:\payload.bin" (attrib -A -R %sd%:\payload.bin)
if exist "%sd%:\exosphere.ini" (attrib -A -R %sd%:\exosphere.ini)
rem Entfernen typischer MacOS Dateien (die sind ueberall die Bruedaz)
if exist .DS_STORE del /s /q /f /a .DS_STORE
if exist ._.* del /s /q /f /a ._.*

REM ================================================================================
:hekateusb
COLOR 0E
echo.
cls
echo --------------------------------------------------------------------------------
echo.
echo     Volle USB3 Geschwindigkeit mit hekate USM Modus!
echo.
echo     1 = USB3 in die Registry eintragen und weiter im Skript!
echo.
echo.
echo     2 = USB3 in die Registry eintragen und zurueck zum Hauptmenue!
echo.
echo --------------------------------------------------------------------------------
echo     H = Zurueck zum Hauptmenue
echo --------------------------------------------------------------------------------
echo.

set /p usb3=Welches Tesla-Overlay soll installiert werden?: 
	if /i "%usb3%"=="1" GOTO usb3weiter
	if /i "%usb3%"=="2" GOTO usb3haupt
	if /i "%usb3%"=="H" GOTO hauptmenue

:usb3haupt
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\11ECA7E0 /v MaximumTransferLength /t REG_DWORD /d 00100000 /f>nul 2>&1
GOTO hauptmenue

:usb3weiter
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\11ECA7E0 /v MaximumTransferLength /t REG_DWORD /d 00100000 /f>nul 2>&1

REM ================================================================================
:aufraeumen
if exist "%sd%:\SwitchBros_BasisPaket" (RD /s /q "%sd%:\SwitchBros_BasisPaket")
if exist "%sd%:\switchbros" (RD /s /q "%sd%:\switchbros")
if exist "%sd%:\switch\switchbros-updater\update.te" (del "%sd%:\switch\switchbros-updater\update.te")
if exist "%sd%:\System Volume Information" (RD /s /q "%sd%:\System Volume Information")
if exist "%sd%:\*.bat" (del "%sd%:\*.bat")
if exist "%sd%:\*.te" (del "%sd%:\*.te")
if exist "%sd%:\*.exe" (del "%sd%:\*.exe")
if exist "%sd%:\*.bak" (del "%sd%:\*.bak")
if exist "%sd%:\SwitchBros_BasisPaket.zip" (del "%sd%:\SwitchBros_BasisPaket.zip")
if exist "%sd%:\SwitchBros.txt" (del "%sd%:\SwitchBros.txt")
if exist "%sd%:\switch\switchbrosupdater" (RD /s /q "%sd%:\switch\switchbrosupdater")

if %bootdat%==0 (
  (
	if exist "%sd%:\bootloader\payloads\hwfly_toolbox.bin" (del "%sd%:\bootloader\payloads\hwfly_toolbox.bin")
	if exist "%sd%:\bootloader\res\icon_hwfly_toolbox_nobox.bmp" (del "%sd%:\bootloader\res\icon_hwfly_toolbox_nobox.bmp")
	if exist "%sd%:\boot.dat" (del "%sd%:\boot.dat")
	if exist "%sd%:\boot.ini" (del "%sd%:\boot.ini") 
	if exist "%sd%:\payload.bin" (del "%sd%:\payload.bin")
	if exist "%sd%:\sdloader.enc" (del "%sd%:\sdloader.enc")
	if exist "%sd%:\firmware.bin" (del "%sd%:\firmware.bin")
	) 
) else (
	if exist "%sd%:\config\fastCFWSwitch" (RD /s /q "%sd%:\config\fastCFWSwitch")
	if exist "%sd%:\config\Fizeau" (RD /s /q "%sd%:\config\Fizeau")
	if exist "%sd%:\switch\Fizeau" (RD /s /q "%sd%:\switch\Fizeau")
	if exist "%sd%:\switch\.overlays\5_Fizeau.ovl" (del "%sd%:\switch\.overlays\*fizeau*.ovl")
	if exist "%sd%:\atmosphere\contents\0100000000000F12" (RD /s /q "%sd%:\atmosphere\contents\0100000000000F12")
	if exist "%sd%:\switch\.overlays\0_fastCFWswitch.ovl" (del "%sd%:\switch\.overlays\fastCFWswitch.ovl")
	if exist "%sd%:\bootloader\payloads\CommonProblemResolver.bin" (del "%sd%:\bootloader\payloads\CommonProblemResolver.bin")
	if not exist "%sd%:\sdloader.enc" (xcopy "%sd%:\switchbros\hwfly\*" "%sd%:\" /H /Y /C /R /S /E /I)
)

cd %sd%:\
GOTO endemutig

REM ================================================================================
:falschesdkarte
cls
COLOR 0C
echo --------------------------------------------------------------------------------
echo                 Gewaehlter Laufwerksbuchstabe: %sd%:/
echo                    Keine SD-Karte in Laufwerk: %sd%:/
echo.
echo.
echo     1.  Laufwerksbuchstabe ist korrekt
echo     2.  Anderen Laufwerksbuchstaben waehlen
echo.
echo --------------------------------------------------------------------------------
echo.
echo     B.  Beenden
echo.

set st=
set /p st=:

for %%A in ("J" "j" "1" "?" "?") do if "%st%"==%%A (GOTO hauptmenue)
for %%A in ("N" "n" "2" "?" "?") do if "%st%"==%%A (GOTO neuekarte)
for %%A in ("B" "b" "?" "?") do if "%st%"==%%A (GOTO endemutig)

REM ================================================================================
:endemutig
COLOR 0A
echo. 
cls
echo --------------------------------------------------------------------------------
echo                           Alles abgeschlossen
echo.
echo                    Viel Spass mit unserem Paket und
echo                 Willkommen in der Switch Bros. Community
echo.
echo.
echo                   Druecke irgendeine Taste zum beenden
echo --------------------------------------------------------------------------------

if exist "%wd%" (RD /s /q "%wd%\*")
pause>nul 2>&1
exit