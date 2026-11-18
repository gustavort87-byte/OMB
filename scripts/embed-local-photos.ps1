param([string]$Html, [string]$PhotoDir)
$ErrorActionPreference = 'Stop'
$entries = @()
foreach ($f in Get-ChildItem -Path $PhotoDir -Filter *.jpeg) {
  $key = $f.Name -replace '^([0-9a-f]+)_', '$1/'
  $bytes = [IO.File]::ReadAllBytes($f.FullName)
  if ($bytes[0] -ne 0xFF -or $bytes[1] -ne 0xD8) { throw "Not a JPEG: $($f.Name)" }
  $entries += "'" + $key + "':'data:image/jpeg;base64," + [Convert]::ToBase64String($bytes) + "'"
}
$js = 'const PHOTOS={' + ($entries -join ",`n") + '};'
$content = [IO.File]::ReadAllText($Html, [Text.Encoding]::UTF8)
if (-not $content.Contains('/*PHOTOS*/')) { throw 'Marker /*PHOTOS*/ not found' }
[IO.File]::WriteAllText($Html, $content.Replace('/*PHOTOS*/', $js), (New-Object Text.UTF8Encoding($false)))
Write-Output "Embedded $($entries.Count) photos"
