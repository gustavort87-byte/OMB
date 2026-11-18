# Arma la carpeta docs/ que publica GitHub Pages:
#   docs/index.html      -> página web (sitio/index.html)
#   docs/app/index.html  -> app de pedidos (prototipo/index.html)
# Los archivos de sitio/ y prototipo/ están en formato "artifact" (sin <html>/<head>),
# así que aquí se envuelven en un documento HTML completo.
# Uso:  powershell -File scripts/build-docs.ps1
param([string]$Root = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$enc = New-Object Text.UTF8Encoding($false)
$out = Join-Path $Root 'docs'
New-Item -ItemType Directory -Force (Join-Path $out 'app') | Out-Null

$head = @'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<style>body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>
</head>
<body>
'@
$tail = "`n</body>`n</html>`n"

# Página web: los botones de "Pedir" abren la app dentro del mismo sitio
$site = [IO.File]::ReadAllText((Join-Path $Root 'sitio\index.html'), [Text.Encoding]::UTF8)
$site = [regex]::Replace($site, "const ORDER_URL='[^']*';", "const ORDER_URL='app/';")
if (-not $site.Contains("const ORDER_URL='app/';")) { throw 'ORDER_URL no encontrado en sitio/index.html' }
[IO.File]::WriteAllText((Join-Path $out 'index.html'), $head + $site + $tail, $enc)

# App de pedidos (prototipo)
$app = [IO.File]::ReadAllText((Join-Path $Root 'prototipo\index.html'), [Text.Encoding]::UTF8)
[IO.File]::WriteAllText((Join-Path $out 'app\index.html'), $head + $app + $tail, $enc)

# GitHub Pages: servir los archivos tal cual, sin Jekyll
[IO.File]::WriteAllText((Join-Path $out '.nojekyll'), '', $enc)

Get-ChildItem -Recurse -Force $out -File | ForEach-Object { "{0,-24} {1,10:N0} bytes" -f $_.FullName.Substring($out.Length), $_.Length }
