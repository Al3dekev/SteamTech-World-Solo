
# 1: Choose a new version for this update
$NewVersion=Read-Host -Prompt "What will be the new version for this update?"

# Line0 = File Name (without extension & dot)
# Line1 = Newer last version
# Line2 = Newer old version
# Line3 = Extension Name (without dot)
$verFile=Get-Content -Path 'version.txt'

$ZipFileName="$($verFile[0]).$($verFile[3])"
$verFile[2] = $verFile[1]
$verFile[1] = $NewVersion
Set-Content -Path 'version.txt' -value $verFile

# 2: Checking if all good files and folders exists
if (!(Test-Path .\OLDVERSIONS\)) {
    mkdir "OLDVERSIONS"
}
cd .\OLDVERSIONS\

echo "Verification de l'existance d'un zip au meme nom avant telechargement..."

if (Test-Path $ZipFileName) {
    echo "Fichier $ZipFileName trouvé suppression en cours..."
    del $ZipFileName
    echo "Fichier $ZipFileName supprimé"
} else {
    echo "Pas de fichier $ZipFileName trouvé."
}

$OldVersionZipName="$($verFile[0]) - $($verFile[2]).$($verFile[3])"

if (Test-Path $OldVersionZipName) {
    echo "Fichier $OldVersionZipName existe déjà, il sera remplacé"
    del $OldVersionZipName
}



# 3: Retrieve old Main version & create "old" release
hub release download Main

ren $ZipFileName $OldVersionZipName

hub release create -o -a $OldVersionZipName -m "Old: $($verFile[2])" $verFile[2]


cd ..

# 4: Delete & Create a new Main Release - Compressing all files

if (Test-Path $ZipFileName) {
    echo "Fichier $ZipFileName existe deja. Il sera supprimé par mesure de sécurité."
    del $ZipFileName
}

if ($verFile[0].Substring($verFile[0].Length - 4) -eq "SOLO") {
    7z a $ZipFileName bin/ config/ mods/ resourcepacks/
} else {
    7z a $ZipFileName libraries/ config/ mods/ $($verFile[0]).jar run.bat minecraft_server.1.12.2.jar
}


echo "Suppression de l'ancien 'Main' release..."
hub release delete Main
echo "Main release supprimée."

echo "Création de la nouvelle release 'Main'..."
hub release create -o -a $ZipFileName -m "Latest: $($verFile[1])" Main

echo "Processus terminé"
PAUSE