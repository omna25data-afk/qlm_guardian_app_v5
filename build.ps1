# ===============================================
# Auto Build Script - Increments build number
# ===============================================

# Set environment variables
$env:PUB_CACHE = "F:\DevZone\pub_cache"
$env:GRADLE_USER_HOME = "F:\DevZone\gradle_cache"

# Read pubspec.yaml
$pubspecPath = "pubspec.yaml"
$content = Get-Content $pubspecPath -Raw -Encoding UTF8

# Extract current version (e.g. 1.0.0+1)
if ($content -match 'version:\s*(\d+\.\d+\.\d+)\+(\d+)') {
    $version = $Matches[1]
    $oldBuild = [int]$Matches[2]
    $newBuild = $oldBuild + 1

    # Update build number in file
    $content = $content -replace "version:\s*$version\+$oldBuild", "version: $version+$newBuild"
    [System.IO.File]::WriteAllText((Resolve-Path $pubspecPath).Path, $content)

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "  Build: $oldBuild --> $newBuild" -ForegroundColor Green
    Write-Host "  Version: $version+$newBuild" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""

    # Build APK
    Write-Host "Building APK..." -ForegroundColor Yellow
    flutter build apk --release -t lib/main_prod.dart

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "===============================================" -ForegroundColor Green
        Write-Host "  BUILD SUCCESS - Version: $version+$newBuild" -ForegroundColor Green
        Write-Host "===============================================" -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "  BUILD FAILED!" -ForegroundColor Red
        # Revert build number on failure
        $content = $content -replace "version:\s*$version\+$newBuild", "version: $version+$oldBuild"
        [System.IO.File]::WriteAllText((Resolve-Path $pubspecPath).Path, $content)
        Write-Host "  Reverted build number to $oldBuild" -ForegroundColor Yellow
    }
}
else {
    Write-Host "ERROR: Could not find version line in pubspec.yaml" -ForegroundColor Red
}
