<#
Safe image optimizer for Windows (PowerShell).
- Creates 'images-backup' (single run backup) to keep original files.
- Optimizes JPEG and PNG in-place using ImageMagick (magick) and/or pngquant if available.
- Keeps original filenames (per your request) — optimized files overwrite originals after backing up.

Usage (PowerShell):
  1) Open powershell in this folder:
     cd "C:\Users\joshc\Desktop\Josh\Invictus Construction Sarnia\ICS Home Website"
  2) Run the script:
     ./optimize-images.ps1

Dependencies:
- ImageMagick (magick) recommended: https://imagemagick.org/script/download.php
- pngquant (optional, better PNG compression): https://pngquant.org/

This script is conservative — it makes a backup and attempts lossless-ish compression with sensible defaults.
#>

$imagesDir = Join-Path $PSScriptRoot 'images'
if (-not (Test-Path $imagesDir)) {
    Write-Host "No 'images' folder found at: $imagesDir" -ForegroundColor Yellow
    exit 1
}

$backupDir = Join-Path $PSScriptRoot 'images-backup'
if (-not (Test-Path $backupDir)) {
    Write-Host "Creating backup folder: $backupDir"
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# gather files
$jpgs = Get-ChildItem -Path $imagesDir -Include *.jpg,*.jpeg -File -Recurse
$pngs = Get-ChildItem -Path $imagesDir -Include *.png -File -Recurse

function Backup-IfNeeded($file) {
    $backupPath = Join-Path $backupDir $file.Name
    if (-not (Test-Path $backupPath)) {
        Write-Host "Backing up $($file.Name) to images-backup/" -ForegroundColor Cyan
        Copy-Item $file.FullName $backupPath -Force
    }
}

$hasMagick = (Get-Command magick -ErrorAction SilentlyContinue) -ne $null
$hasPngquant = (Get-Command pngquant -ErrorAction SilentlyContinue) -ne $null

if (-not $hasMagick -and -not $hasPngquant) {
    Write-Host "Warning: neither ImageMagick (magick) nor pngquant found. Install one for best results." -ForegroundColor Yellow
}

# Optimize JPEGs
foreach ($f in $jpgs) {
    Backup-IfNeeded $f
    Write-Host "Optimizing JPEG: $($f.Name)" -ForegroundColor Green
    if ($hasMagick) {
        # Use magick convert to strip metadata and set quality; overwrite safely to a temp file then replace
        $temp = [System.IO.Path]::ChangeExtension($f.FullName, ".tmp.jpg")
        & magick convert "$($f.FullName)" -strip -interlace Plane -sampling-factor 4:2:0 -quality 78 "$temp"
        if (Test-Path $temp) { Move-Item -Force $temp $f.FullName }
    } else {
        Write-Host "Skipping heavy JPG compression for $($f.Name). Install ImageMagick for best results." -ForegroundColor Yellow
    }
}

# Optimize PNGs
foreach ($f in $pngs) {
    Backup-IfNeeded $f
    Write-Host "Optimizing PNG: $($f.Name)" -ForegroundColor Green
    if ($hasPngquant) {
        # pngquant will overwrite the file when using --ext and --force
        & pngquant --quality=60-85 --speed=1 --force --ext .png "$($f.FullName)"
    } elseif ($hasMagick) {
        # Reduce PNG size using magick
        $temp = [System.IO.Path]::ChangeExtension($f.FullName, ".tmp.png")
        & magick convert "$($f.FullName)" -strip -quality 85 "$temp"
        if (Test-Path $temp) { Move-Item -Force $temp $f.FullName }
    } else {
        Write-Host "Skipping PNG compression for $($f.Name). Install pngquant or ImageMagick for best results." -ForegroundColor Yellow
    }
}

Write-Host "Optimization complete. Original files were kept in images-backup/" -ForegroundColor Green
Write-Host "If you want further lossy reductions (smaller files), run the script again with adjusted quality settings or use advanced tools." -ForegroundColor Cyan
