$ErrorActionPreference = 'Stop'
$workspacePath = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$dartVersion = '3.12.2'
$toolchainPath = Join-Path $workspacePath 'tmp\toolchains'
$dartPath = Join-Path $toolchainPath 'dart-sdk\bin\dart.exe'
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Install Node.js 22 or newer before starting CareGrid.' }
if (-not (Test-Path -LiteralPath $dartPath)) {
  New-Item -ItemType Directory -Force -Path $toolchainPath | Out-Null
  $archivePath = Join-Path $toolchainPath 'dart-sdk.zip'
  $downloadUrl = 'https://storage.googleapis.com/dart-archive/channels/stable/release/' + $dartVersion + '/sdk/dartsdk-windows-x64-release.zip'
  Write-Output ('Downloading the pinned Dart ' + $dartVersion + ' SDK into ignored tmp/toolchains. First launch also downloads Serverpod dependencies and PostgreSQL binaries.')
  Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath -UseBasicParsing
  $checksumText = (Invoke-WebRequest -Uri ($downloadUrl + '.sha256sum') -UseBasicParsing).Content
  $expectedHash = ($checksumText -split '\s+')[0]
  $actualHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash
  if ($actualHash -ine $expectedHash) { throw 'Dart SDK checksum mismatch. Refusing to extract this archive.' }
  Expand-Archive -LiteralPath $archivePath -DestinationPath $toolchainPath -Force
}
$env:DART_EXECUTABLE = $dartPath
Push-Location -LiteralPath $workspacePath
try { node scripts/dev.mjs; if ($LASTEXITCODE -ne 0) { throw ('CareGrid exited with code ' + $LASTEXITCODE) } }
finally { Pop-Location }
