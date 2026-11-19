param([switch]$MobileOnly)
$ErrorActionPreference = 'Stop'
$workspacePath = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$chromeCandidates = @(
  'C:\Program Files\Google\Chrome\Application\chrome.exe',
  'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
)
$chromePath = $chromeCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $chromePath) { throw 'Google Chrome is required for this optional screenshot export.' }
New-Item -ItemType Directory -Force -Path (Join-Path $workspacePath 'tmp'), (Join-Path $workspacePath 'assets\pitch') | Out-Null
$shots = @(
  @{Name='01-command-centre'; Url='?demo=verified#overview'; Size='1600,1100'},
  @{Name='02-incident-workspace'; Url='?demo=dispatched#incident'; Size='1600,1250'},
  @{Name='03-responder'; Url='?demo=active#responder'; Size='1600,1100'},
  @{Name='04-care-console'; Url='?demo=care#care'; Size='1600,1100'},
  @{Name='05-readiness-lab'; Url='?demo=readiness#readiness'; Size='1600,1150'},
  @{Name='06-after-action'; Url='?demo=outcome#analytics'; Size='1600,1200'},
  # Windows Chrome has a minimum headless viewport near 500 CSS px.
  # 540 avoids a screenshot narrower than the actual rendered viewport.
  @{Name='07-mobile-responder'; Url='?demo=active#responder'; Size='540,1200'},
  @{Name='08-mobile-command'; Url='?demo=verified#overview'; Size='540,1200'}
)
if ($MobileOnly) { $shots = $shots | Where-Object { $_.Name -like '*mobile*' } }
foreach ($shot in $shots) {
  $imagePath = Join-Path $workspacePath ('assets\pitch\' + $shot.Name + '.png')
  $profilePath = Join-Path $workspacePath ('tmp\render-' + $shot.Name)
  $logPath = Join-Path $workspacePath ('tmp\render-' + $shot.Name + '.log')
  $arguments = @('--headless=new','--no-first-run','--disable-gpu','--disable-background-networking','--disable-component-update','--hide-scrollbars',('--user-data-dir="' + $profilePath + '"'),('--window-size=' + $shot.Size),('--screenshot="' + $imagePath + '"'),'--virtual-time-budget=2500',('"http://127.0.0.1:4173/index.html' + $shot.Url + '"'))
  Start-Process -FilePath $chromePath -ArgumentList $arguments -WindowStyle Hidden -Wait -RedirectStandardError $logPath
  if (-not (Test-Path -LiteralPath $imagePath)) { throw ('Capture missing: ' + $shot.Name) }
  $file = Get-Item -LiteralPath $imagePath
  Write-Output ($file.Name + ' / ' + $file.Length + ' bytes')
}
