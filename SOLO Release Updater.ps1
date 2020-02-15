
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
    echo "Fichier $ZipFileName trouv� suppression en cours..."
    del $ZipFileName
    echo "Fichier $ZipFileName supprim�"
} else {
    echo "Pas de fichier $ZipFileName trouv�."
}

$OldVersionZipName="$($verFile[0]) - $($verFile[2]).$($verFile[3])"

if (Test-Path $OldVersionZipName) {
    echo "Fichier $OldVersionZipName existe d�j�, il sera remplac�"
    del $OldVersionZipName
}



# 3: Retrieve old Main version & create "old" release
hub release download Main

ren $ZipFileName $OldVersionZipName

hub release create -o -a $OldVersionZipName -m "Old: $($verFile[2])" $verFile[2]


cd ..

# 4: Delete & Create a new Main Release - Compressing all files

if (Test-Path $ZipFileName) {
    echo "Fichier $ZipFileName existe deja. Il sera supprim� par mesure de s�curit�."
    del $ZipFileName
}

7z a $ZipFileName bin/ config/ mods/ resourcepacks/

echo "Suppression de l'ancien 'Main' release..."
hub release delete Main
echo "Main release supprim�e."

echo "Cr�ation de la nouvelle release 'Main'..."
hub release create -o -a $ZipFileName -m "Latest: $($verFile[1])" Main

echo "Processus termin�"
PAUSE