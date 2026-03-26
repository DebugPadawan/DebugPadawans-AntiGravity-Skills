param(
    [Parameter(Mandatory=$true)]
    [string]$Term,
    [Parameter(Mandatory=$true)]
    [string]$Extension
)

# Optimized dependency tracer for Windows (PowerShell)
# Usage: .\dependency_trace.ps1 -Term "getUserData" -Extension ".js"

if (-not $Extension.StartsWith(".")) { $Extension = "*." + $Extension } else { $Extension = "*" + $Extension }

Write-Host "`n>>> 1. Direct References in $Extension files" -ForegroundColor Cyan
$allMatches = Get-ChildItem -Path . -Filter $Extension -Recurse | Select-String -Pattern $Term
foreach ($m in $allMatches) {
    Write-Host ("{0,-30} L{1,-5} | {2}" -f (Resolve-Path -LiteralPath $m.Path -Relative), $m.LineNumber, $m.Line.Trim()) -ForegroundColor Green
}

Write-Host "`n>>> 2. Module Import Impact" -ForegroundColor Cyan
$affectedFiles = $allMatches | Select-Object -Property Path -Unique | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Path) } | Sort-Object -Unique
foreach ($file in $affectedFiles) {
    if ($file) {
        $imports = Get-ChildItem -Path . -Filter $Extension -Recurse | Select-String -Pattern $file | Where-Object { $_.Path -notlike "*$file$Extension" }
        foreach ($i in $imports) {
            Write-Host ("{0,-30} Imports: {1,-15} (L{2})" -f (Resolve-Path -LiteralPath $i.Path -Relative), $file, $i.LineNumber) -ForegroundColor Yellow
        }
    }
}

Write-Host "`n>>> 3. Structural Risks (Shared State / Scope)" -ForegroundColor Cyan
$filesToScan = $allMatches | Select-Object -Property Path -Unique
foreach ($f in $filesToScan) {

    $risks = Select-String -Path $f.Path -Pattern "global|static|volatile|public|private|class"
    foreach ($r in $risks) {
        Write-Host ("{0,-30} Risk: {1,-15} (L{2})" -f (Resolve-Path -LiteralPath $f.Path -Relative), $r.Matches[0].Value, $r.LineNumber) -ForegroundColor Red
    }
}

Write-Host "`nAnalysis Complete.`n" -ForegroundColor Cyan
