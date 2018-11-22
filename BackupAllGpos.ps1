<#
    Backup Script for GPOs
    Arne Tiedemann
    2018-10-10

#>

# Default variables
$DaysBack = 31
$DateEnd = (Get-Date).AddDays(-$DaysBack)

# Backup Path
$PathBackup = 'D:\Backup\GPO'

#################################################
# Script
#################################################

# Check path
if (-not(Test-Path -Path $PathBackup -ErrorAction SilentlyContinue)) {
    $null = New-Item -Path $PathBackup -Force -ItemType Directory
}

# Backup
Get-GPO -All |
    ForEach-Object { $_.DisplayName; $Null = Backup-GPO -Guid $_.Id -Path $PathBackup -ErrorAction SilentlyContinue }

# Remove old Items
if (Test-Path -Path $PathBackup -ErrorAction SilentlyContinue) {
    Get-ChildItem -Path $PathBackup |
        Where-Object { $_.LastWriteTime -lt $DateEnd } |
        Remove-Item -Recurse -Force
}
