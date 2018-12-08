@echo off
::ZIP FILE NAME VARIABLE
set commonname="SteamTechWorldSOLO"
set oldername="SteamTech.World.-.SOLO"


::ZIP VARIABLE
set zipext=.zip
set commonzipname=%commonname%%zipext%
set olderzipname=%oldername%%zipext%



::TAKING BACK ANCIENT VER
cd .\OLDVERSIONS\

echo Verification de l'existance d'un zip au meme nom avant telechargement...
echo .

if exist %commonzipname% (
	echo Fichier %commonzipname% trouve, supression en cours...
	del %commonzipname%
	echo Fichier supprime
) else ( echo pas de fichier %commonzipname% trouve )


if exist %olderzipname% (
	echo Fichier %olderzipname% trouve, supression en cours...
	del %olderzipname%
	echo Fichier supprime
) else ( echo pas de fichier %olderzipname% trouve )




hub release download Main

::CHOOSE NEW ZIP NAME FOR THE OLDER VER
set /p oldversion="[NUMERO ANCIENNE VERSION POUR ZIP]: "
set versioningzipname="%commonname% - %oldversion%%zipext%"


echo %versioningzipname%

if exist %versioningzipname% (
echo .
del %versioningzipname%
echo .
echo %versioningzipname% was existing, it has been deleted
echo.
)


if exist %olderzipname% (

ren %olderzipname% %versioningzipname%

) else ( ren %commonzipname% %versioningzipname% )

::OLD VERSION ONLINE
hub release create -o -a %versioningzipname% -m "OLD: %oldversion%" %oldversion%


cd ..

7z a %commonzipname% bin/ config/ mods/
echo "Suppression de la Release precedente..."
hub release delete Main
echo "Release supprimee."

echo "Creation d'une Release..."
set /p newversion="[NUMERO NOUVELLE VERSION POUR TITRE RELEASE]: "

hub release create -o -a %commonzipname% -m %newversion% Main


:devtestend
PAUSE