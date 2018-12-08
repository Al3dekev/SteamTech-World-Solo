@echo off
::ZIP VARIABLE
set zipfile="SteamTechWorldSOLO.zip"

cd ..
hub download MAIN

cd '.\SteamTech World - SOLO\'

set /p zipvername="Version ancien zip: "
set newZip="Steamtech World - SOLO - "%zipvername%".zip"
ren ../%zipfile% %newZip%

hub release create -o -a %newZip% -m %zipvername% %zipvername%



7z a %zipfile% bin/ config/ mods/
echo "Suppression de la Release precedente..."
hub release delete Main
echo "Release supprimee."

echo "Creation d'une Release:"
set /p titre="Titre: "

hub release create -o -a %zipfile% -m %titre% Main
PAUSE