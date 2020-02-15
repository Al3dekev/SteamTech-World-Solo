# Line0 = File Name (without extension & dot)
# Line1 = Newer last version
# Line2 = Newer old version
# Line3 = Extension Name (without dot)
$verFile=Get-Content -Path 'version.txt'

$ZipFileName="$($verFile[0]).$($verFile[3])"

if (Test-Path $ZipFileName){
    echo "File already exists, will be overwrited"
    del $ZipFileName
}

7z a $ZipFileName bin/ config/ mods/ resourcepacks/