$totalLines = 0
Get-ChildItem -Recurse -Filter "*.dart" | Where-Object {!($_.Name -like "*.g.dart" -or $_.Name -like "*.freezed.dart" -or $_.Name -like "*.gr.dart" -or $_.Name -like "*.gen.dart")} | ForEach-Object {
    $lineCount = (Get-Content $_.FullName | Measure-Object -Line).Lines
    $totalLines += $lineCount
    Write-Host "$($_.Name): $lineCount lines"
}

Write-Host "Total lines: $totalLines"