# Prompt the user for the new version number
$newVersionNumber = Get-Content -Path ".\version.txt"

# Define the path where the Lua files are located
$PACKAGE = "package.json"
$CCFILE = "src\CC.lua"
$CCINFO = "src\CompanionsCompanion.txt"

# Update CompanionsCompanion.txt
$content = Get-Content -Path $CCINFO
$updatedContent = $content -replace '(?<=## Version: ).*', $newVersionNumber
Set-Content -Path $CCINFO -Value $updatedContent

# Update CC.lua
$content = Get-Content -Path $CCFILE
$updatedContent = $content -replace '(?<=VERSION      = ").*"', "$newVersionNumber`""
Set-Content -Path $CCFILE -Value $updatedContent

# Update package.json
$content = Get-Content -Path $PACKAGE
$updatedContent = $content -replace '(?<="version": ")[^"]*', $newVersionNumber
$updatedContent | Out-File -FilePath $PACKAGE -Encoding utf8

# Fin
Write-Output "Version numbers updated successfully!"
