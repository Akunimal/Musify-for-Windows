# Quality Gate — run before every build to catch common breakage

param([switch]$Fix)

$ErrorActionPreference = "Stop"
$root = "C:\Extension\Musify"
$ok = 0; $total = 0

Write-Host "=== Quality Gate ===" -Foreground Cyan

# 1) Check for unclosed brackets/syntax in Dart files
$total++
$bad = @()
Get-ChildItem "$root\lib" -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $opens = [regex]::Matches($content, '[{([]').Count
    $closes = [regex]::Matches($content, '[})\]]').Count
    if ($opens -ne $closes) {
        $bad += $_.FullName
    }
}
if ($bad.Count -eq 0) { $ok++; Write-Host "  ✓ Bracket balance" -Foreground Green }
else { Write-Host "  ✗ Bracket mismatch in: $bad" -Foreground Red }

# 2) Check for Android-only code without Platform guard
$total++
$unguarded = @()
Get-ChildItem "$root\lib" -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "AndroidEqualizer|AndroidLoadControl|setAndroidAudioAttributes|androidAudioEffects") {
        # Check if Platform.isAndroid guard exists
        if ($content -notmatch "Platform\.isAndroid") {
            $unguarded += $_.FullName
        }
    }
}
if ($unguarded.Count -eq 0) { $ok++; Write-Host "  ✓ Android guards" -Foreground Green }
else { Write-Host "  ✗ Unguarded Android code: $unguarded" -Foreground Red }

# 3) No duplicate AnimatedBackground
$total++
$dup = @()
Get-ChildItem "$root\lib" -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "AnimatedBackground" -and $_.Name -ne "animated_background.dart" -and $_.Name -ne "main.dart") {
        $dup += $_.FullName
    }
}
if ($dup.Count -eq 0) { $ok++; Write-Host "  ✓ No duplicate bg" -Foreground Green }
else { Write-Host "  ✗ Duplicate bg in: $dup" -Foreground Red }

# 4) Check exe integrity
$total++
$exe = "$root\dist\musify.exe"
if (Test-Path $exe) {
    $bytes = [System.IO.File]::ReadAllBytes($exe)
    if ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) { $ok++; Write-Host "  ✓ PE header valid" -Foreground Green }
    else { Write-Host "  ✗ Invalid PE header" -Foreground Red }
} else { Write-Host "  ✗ exe not found (run build first)" -Foreground Red }

# 5) Smoke test
$total++
$p = Start-Process -FilePath $exe -WorkingDirectory "$root\dist" -NoNewWindow -PassThru
Start-Sleep -Seconds 3
if (!$p.HasExited) { $p.Kill(); $ok++; Write-Host "  ✓ Smoke OK (3s)" -Foreground Green }
else { Write-Host "  ✗ Process exited early (code $($p.ExitCode))" -Foreground Red }

$pass = $ok -eq $total
Write-Host "`n=== Quality Gate: $ok/$total passed ===$('' | %{if($pass){' ✅'}else{' ❌'}})" -Foreground $(if($pass){'Green'}else{'Red'})
if (!$pass) { exit 1 }

# If -Fix passed, rebuild
if ($Fix) {
    Write-Host "`nRebuilding..." -Foreground Cyan
    & cmd.exe /c "C:\temp\portable_build.bat"
}
