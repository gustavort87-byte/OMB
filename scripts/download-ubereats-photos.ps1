param([string]$Html, [string]$OutDir)
$ErrorActionPreference = 'Stop'
$base = 'https://tb-static.uber.com/prod/image-proc/processed_images/'
$A1 = 'a1681d67ebe55c76c3af5f401619c278.jpeg'; $C6 = 'c67fc65e9b4e16a553eb7574fba090f1.jpeg'
$paths = @(
  "92b55a5f19bd4cf073fc97165fcc61ea/63cdd1044c1bf03a6f4ce3a9422016b8.jpeg",
  "995a1b27e62fe3cf8dd8b2477611170a/$A1", "006204e8d07507d10ba3cc63b63b5286/$A1",
  "671ef8dd6e312f5dd87e908536a26ece/$A1", "cd3246294674c59c477983a8c9f07d2f/$A1",
  "7db6ffd7b2542071e55c3d02227b41c6/$A1", "547e2d624116189964664f2e7b9494bc/$C6",
  "e5c8388c4e48d69f77bd35fee673dba7/$C6", "4ca15db84c6647d9a2a670408e2fd76b/$A1",
  "febe77242c16681740ea13838bc0f6e4/$A1", "bb8dbe9f032c6fe2da41619fefca66da/$C6",
  "3390e8a3552b05697575e8963437e314/$A1", "453d5e2973d76283f001bde77cba593c/$C6",
  "25bcab900ca6c3e251847230edc664d7/$C6"
)
New-Item -ItemType Directory -Force $OutDir | Out-Null
$entries = @(); $total = 0
foreach ($p in $paths) {
  $file = Join-Path $OutDir (($p -replace '/', '_'))
  Invoke-WebRequest -Uri ($base + $p) -OutFile $file -UseBasicParsing
  $bytes = [IO.File]::ReadAllBytes($file)
  # sanity check: JPEG magic bytes
  if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xFF -or $bytes[1] -ne 0xD8) { throw "Not a JPEG: $p" }
  $total += $bytes.Length
  $entries += "'" + $p + "':'data:image/jpeg;base64," + [Convert]::ToBase64String($bytes) + "'"
  Write-Output ("{0,-80} {1,8:N0} bytes" -f $p, $bytes.Length)
}
$js = 'const PHOTOS={' + ($entries -join ",`n") + '};'
$content = [IO.File]::ReadAllText($Html, [Text.Encoding]::UTF8)
if (-not $content.Contains('/*PHOTOS*/')) { throw 'Marker /*PHOTOS*/ not found' }
$content = $content.Replace('/*PHOTOS*/', $js)
[IO.File]::WriteAllText($Html, $content, (New-Object Text.UTF8Encoding($false)))
Write-Output ("TOTAL {0:N0} bytes in {1} photos" -f $total, $paths.Count)
