@echo off
::*******************************************************************************************************
:: mw2012, TrueCryptcontainer mit dieser BATCH-Datei automatisch mit Wunschlaufwerksbuchstabe mounten****
:: Wenn Buchstabe schon belegt, wird erster freier Buchstabe im System genommen und als Hinweis ausgeben*
:: Achtung: Dieser Batchdatei muss im selben Ordner wie TrueCrpt.exe sowie Containerdatei liegen!********
:: Dass Kennwort bzw. die Passphrase wird nach dem Aufruf abgefragt. Bitte NIE hier hinterlegen!!!!!!!!!*
::*******************************************************************************************************

::*****Ab hier Änderung ERFORDERLICH!******************************
:: In nächster Zeile 'J' durch Wunschlaufwerksbuchstaben ersetzen:
set Wunsch_LW=J
:: In nächster Zeile 'daten3' durch Containernamen ersetzen:
set Container=daten3
::*****Ab hier KEINE Änderungen machen*****************************

:: wenn Laufwerk nicht vorhanden, dann mounten
:: An dieser Stelle könnten man noch einen Anti-Keylogger einbauen, z.B. MOK
cd %Wunsch_LW%: && goto LW_Vorhanden
REM Fehlermeldung,dass LW nicht vorhanden (gewollt), lässt sich mir 2>NUL und >NUL nicht umleiten
echo ...und daher den gewollten Laufwerksbuchstaben benutzen.
%cd%\TrueCrypt.exe /v %cd%\%Container% /l %Wunsch_LW% /a /quit
exit

:: Wenn Laufwerk vorhanden, dann ersten freien Buchstaben suchen > 
:: Quelle: Codeschnipsel aus http://www.heise.de/ct/hotline/Freien-Laufwerksbuchstaben-finden-322906.html
:LW_Vorhanden  
if not "%OS%"=="Windows_NT" exit /b
setlocal
set ll=D E F G H I J K L M N O P Q R S T U V W X Y Z
for %%l in (%ll%) do (
 set LW=%%l
 mountvol %%l: /L >nul
 if errorlevel 1 (
 subst | findstr /B "%%l:" > nul
 if errorlevel 1 (
 net use %%l: >nul 2>&1
 if errorlevel 1 goto gotone
 )
 )
)
echo Zurzeit ist kein Laufwerksbuchstabe frei! Container konnte nicht nicht eingebunden werden!
pause
exit /b
:gotone

:: Laufwerk unter gefundenem freien Buchstaben mounten und Hinweismeldung ausgeben
%cd%\TrueCrypt.exe /v %cd%\%Container% /l %LW% /a /quit
echo Der gewünschte Laufwerksbuchstabe ist schon vergeben. Der Container ist nun erfolgreich als Laufwerk %LW%: eingebunden.
pause
exit