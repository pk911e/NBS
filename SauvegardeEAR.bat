echo off

title Sauvegarde Des EARs V1.6

rem =======================================================================================
rem =================                Script realise par                   =================
rem =================                 SCH MEDARD Fabien                   =================
rem =================                  1ฐ Cie du 48 RT                    =================
rem =================                                                     =================
rem =================                  MAJ 09/05/2015                     =================
rem =======================================================================================
rem =======================================================================================
rem =================                                                     =================
rem =================                TOUS DROITS RESERVES                 =================
rem =================                                                     =================
rem ================= Pour toutes modifications veuillez adressez un mail =================
rem =================                fabien.medard@gmail.com              =================
rem =======================================================================================
rem =======================================================================================
cls
echo ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                         Sauvegarde Des EARs V1.6                            บ
echo ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
                

rem couleur du script
color 0A

rem creation de la variable udate pour changer le format de lheure
set year=%DATE:~6,4%
set month=%DATE:~3,2%
set day=%DATE:~0,2%
set udate=%year%-%month%-%day%
set count=0
set count2=0
set Seffectue=0
set Sechec=0
set Sabandon=0
set EAR=AUCUN
set IPEAR=AUCUN
set model=AUCUN

FOR /F "eol=!" %%c in (d:\Script\Variables.txt) DO call :commande3 %%c  

:commande3

set /a count = count + 1

IF %count%==1 (set ServeurTFTP=%1)
IF %count%==2 (set IDSave=%1)
IF %count%==3 (set MDPSave=%1)
IF %count%==4 (set Racine=%1)
IF %count%==5 (set RepSave=%1)
IF %count%==6 (set Classification=%1)
IF %count%==7 (set DossierScript=%1)
IF %1==FINVARIABLES (goto FinCommande3)

goto EOF

:FinCommande3

set count=0


rem positionnement dans le bon repertoire
%Racine%
cd \

rem creation du repertoire de sauvegarde
IF exist %Racine%\%RepSave%\ goto rep1
IF NOT exist %Racine%\%RepSave%\ echo Creation du repertoire de sauvegarde.
IF NOT exist %Racine%\%RepSave%\ mkdir %RepSave%
:rep1
cd %RepSave%

rem creation du repertoire de l'ann้e
IF exist %Racine%\%RepSave%\%year% goto rep2
IF NOT exist %Racine%\%RepSave%\%year% echo Creation du repertoire %year%
IF NOT exist %Racine%\%RepSave%\%year% mkdir %year%
:rep2
cd %year%

rem creation du repertoire du mois
IF exist %Racine%\%RepSave%\%year%\%year%-%month% goto rep3
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month% echo Creation du repertoire %year%-%month%
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month% mkdir %year%-%month%
:rep3
cd %year%-%month%

rem creation du repertoire du Jour
IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% goto rep4
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% echo Creation du repertoire %udate%
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% mkdir %udate%
:rep4
cd %udate%

IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% cls
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% echo Erreur lors de la creation du repertoire
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% echo.
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% echo Fin du Script !
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate% goto FinScript

rem =============================================================================================
rem ==================================== DEBUT SAUVEGARDE  ======================================
rem =============================================================================================

%Racine%
cd \

echo.
echo Verification disponibilite du service TFTP.
echo.

TIMEOUT /T 1

NET START > netstart.txt
FOR /F "tokens=2,3*" %%i in ('FIND "TFTP" netstart.txt /c') do set ServiceTFTP=%%j
DEL netstart.txt

IF %ServiceTFTP%==1 (
	echo.
	echo   [ OK ] Le Service TFTP est bien demarre
	echo.
	goto FinTestTFTP
	)

IF %ServiceTFTP%==0 (
	echo.		
	echo [ ERREUR ] Le Service TFTP n est pas demarre
	echo.
	pause
	goto  rep4
	)
	

:FinTestTFTP

TIMEOUT /T 2

FOR /F %%a in (%Racine%\%DossierScript%\EAR.txt) DO call :commande %%a 

:commande

set model=%1
set EAR=%2
set IPEAR=%3

IF %model%==cisco goto EARCisco
IF %model%==3Com goto EAR3Com
IF %model%==FINEAR goto FinEAR

echo.
echo Probleme de saisie du modele dans le fichier EAR.txt
echo.

goto :finScript

rem =====================================================================
rem =====================                           =====================
rem =====================          CISCO            =====================
rem =====================                           =====================
rem =====================================================================

:EARCisco

set /a count = count + 1

echo ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ            Sauvegarde De %EAR% / %IPEAR%        
echo ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

echo อออออออออ[ 01. Recherche d une precedente sauvegarde de %EAR%

IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (
	echo อออออออออ[ 02. Sauvegarde detecte pour %EAR%
	echo                           Abandon de la sauvegarde
	echo.
	set /a Sabandon = Sabandon + 1
	goto FinEAR
	)

IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (
	echo อออออออออ[ 02. Aucune sauvegarde detecte pour %EAR%
	echo อออออออออ[ 03. Creation de la sauvegarde de %EAR%
	)

echo อออออออออ[ 04. Connexion a %EAR%

"%Racine%\%DossierScript%\plink.exe" -ssh %IDSave%@%IPEAR% -pw %MDPSAVE% "copy run tftp://%ServeurTFTP%/%EAR%.rtf"

echo.
echo อออออออออ[ 05. Deconnexion de %EAR%
echo อออออออออ[ 06. Deplacement du fichier de sauvegarde %EAR%.rtf

move %Racine%\%RepSave%\%EAR%.rtf %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf

echo อออออออออ[ 07. Fin sauvegarde de la configuration de %EAR%
echo อออออออออ[ 08. Verification de la sauvegarde de %EAR%

IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (
	set /a Seffectue = Seffectue + 1
	)
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (
	echo อออออออออ[ 09. Echec de la sauvegarde de %EAR%
	set /a Sechec = Sechec + 1
	)

goto FinEAR

rem ========================== FIN Cisco ===========================

rem =====================================================================
rem =====================                           =====================
rem =====================          3Com             =====================
rem =====================                           =====================
rem =====================================================================

:EAR3Com

set /a count = count + 1

echo ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ            Sauvegarde De %EAR% / %IPEAR%        
echo ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

echo อออออออออ[ 01. Recherche d une precedente sauvegarde de %EAR%

IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo อออออออออ[ 02. Sauvegarde detecte pour %EAR%
	echo                           Abandon de la sauvegarde
	echo.
	set /a Sabandon = Sabandon + 1
	goto FinEAR
)

IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo อออออออออ[ 02. Aucune sauvegarde detecte pour %EAR%
	echo อออออออออ[ 03. Creation de la sauvegarde de %EAR%
)

echo อออออออออ[ 04. Connexion a %EAR%

"%Racine%\%DossierScript%\plink.exe" -ssh %IDSave%@%IPEAR% -pw %MDPSAVE% "tftp %ServeurTFTP% put save.cfg %EAR%.txt"

echo.
echo อออออออออ[ 05. Deconnexion de %EAR%
echo อออออออออ[ 06. Deplacement du fichier de sauvegarde %EAR%.txt

move %Racine%\%RepSave%\%EAR%.txt %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt

echo อออออออออ[ 07. Fin sauvegarde de la configuration de %EAR%
echo อออออออออ[ 08. Verification de la sauvegarde de %EAR%
IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo อออออออออ[ 09. Reussite de la sauvegarde de %EAR%
	set /a Seffectue = Seffectue + 1
	)
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo อออออออออ[ 09. Echec de la sauvegarde de %EAR%
	set /a Sechec = Sechec + 1
	)

goto FinEAR

rem ========================== FIN 3 Com ===========================

:FinEAR

IF %model%==FINEAR (goto Resultat)

goto EOF


rem =============================== RESULTAT DES SAUVEGARDES ==============================
:Resultat

cls
echo ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                         Sauvegarde Des EARs V1.6                            บ
echo ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                                             บ
echo                     RESEAU : %Classification%
echo บ                                                                             บ
echo ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo ______________________________________________________________________________
echo.
echo                    Etat des sauvegardes du %day%-%month%-%year%
echo.
echo ______________________________________________________________________________
echo.

set Passe=0

FOR /F %%b in (%Racine%\%DossierScript%\EAR.txt) DO call :commande2 %%b 
:commande2

set model=%1
set EAR=%2
set IPEAR=%3

IF %model%==cisco goto EARCisco2
IF %model%==3Com goto EAR3Com2
IF %model%==FINEAR goto FinResultat
IF %Passe%==1 goto EOF
:EARCisco2
IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (
	echo     [ OK ] %EAR%
	)
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.rtf (

	echo  [ ECHEC ] %EAR%   
	)
goto EOF
rem goto FinEAR2
:EAR3Com2
IF exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo     [ OK ] %EAR%
	)
IF NOT exist %Racine%\%RepSave%\%year%\%year%-%month%\%udate%\%EAR%.txt (
	echo  [ ECHEC ] %EAR%  
	)
goto EOF
rem goto FinEAR2

:FinEAR2

goto EOF


:FinResultat
	IF NOT %Passe%==1 (
	echo.
	echo ______________________________________________________________________________
	echo.
	echo           Nouvelle :    %seffectue% / %count%
	echo.
	echo           Anterieure :  %Sabandon% / %count%
	echo.
	echo           Echec :       %sechec% / %count%
	echo ______________________________________________________________________________
	set Passe=1
	TIMEOUT /T 14400
	)
:FinScript
:EOF