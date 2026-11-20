<#
.SYNOPSIS
Bind an existing Google sign-in to an existing CareGrid membership.
.EXAMPLE
./scripts/bind-google-user.ps1 -Email teammate@example.com -Handle niet.command
.EXAMPLE
./scripts/bind-google-user.ps1 -Email teammate@example.com -Handle niet.command -CheckOnly
#>
[CmdletBinding(DefaultParameterSetName='Bind')]
param(
  [Parameter(Mandatory=$true,ParameterSetName='Bind')][ValidatePattern('^[^\s@]+@[^\s@]+\.[^\s@]+$')][string]$Email,
  [Parameter(Mandatory=$true,ParameterSetName='Bind')][ValidatePattern('^[a-z][a-z0-9.]{1,63}$')][string]$Handle,
  [Parameter(Mandatory=$true,ParameterSetName='List')][switch]$ListRoles,
  [ValidatePattern('^[a-z][a-z0-9-]+$')][string]$Project = 'caregrid-staging',
  [ValidatePattern('^[a-z]+-[a-z]+[0-9]+$')][string]$Region = 'asia-south1',
  [ValidatePattern('^[a-z][a-z0-9-]+$')][string]$Job = 'caregrid-demo-bootstrap',
  [string]$Gcloud = 'gcloud',
  [Parameter(ParameterSetName='Bind')][switch]$CheckOnly
)
$ErrorActionPreference = 'Stop'
if ($ListRoles) {
  $seedPath = Join-Path $PSScriptRoot '../caregrid_server/lib/src/seed'
  # Meridian uses Dart record literals; NIET/network use SeedUser constructors.
  $pattern = "\(\s*'([^']+)',\s*'([^']+)',\s*UserRole\.(\w+)"
  $members = foreach ($file in Get-ChildItem -LiteralPath $seedPath -Filter '*.dart' -File) {
    foreach ($match in [regex]::Matches((Get-Content -LiteralPath $file.FullName -Raw), $pattern)) {
      [pscustomobject]@{Handle=$match.Groups[1].Value;Role=$match.Groups[3].Value;Persona=$match.Groups[2].Value}
    }
  }
  $members | Sort-Object Handle -Unique | Format-Table -AutoSize
  Write-Output 'These are source-defined synthetic memberships, not a query of live bindings.'
  return
}
$token = $null
$headers = $null
try {
  # Uses the operator's existing gcloud profile. Does not log in, create users,
  # save credentials, or change the active project/profile.
  $token = (& $Gcloud auth print-access-token --quiet) -join ''
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($token)) { throw 'Authenticate the deployment operator with gcloud first.' }
  $headers = @{Authorization=('Bearer '+$token); 'x-goog-user-project'=$Project}
  $lookup = Invoke-RestMethod -Method Post -Headers $headers -TimeoutSec 60 -ContentType 'application/json' `
    -Uri "https://identitytoolkit.googleapis.com/v1/projects/$Project/accounts:lookup?fields=users(localId,email,disabled,providerUserInfo(providerId))" `
    -Body (@{email=@($Email)} | ConvertTo-Json -Compress)
  $users = @($lookup.users | Where-Object {$_.email -ieq $Email})
  if ($users.Count -ne 1) { throw 'No unique Firebase user exists. Sign in with Google on /console once, then run this command again.' }
  $user = $users[0]
  if ($user.disabled -or 'google.com' -notin @($user.providerUserInfo.providerId)) { throw 'An enabled Google sign-in is required.' }
  if ($CheckOnly) {
    Write-Output "Existing Google identity found. Proposed membership: $Handle. No binding executed."
    return
  }
  # REST arrays preserve separate arguments on Windows; comma-separated .cmd
  # arguments previously launched the wrong entry point. The private bootstrap
  # job enforces existing membership, no replacement and global UID uniqueness.
  $body = @{overrides=@{containerOverrides=@(@{args=@('bootstrap','bind',$Handle,$user.localId)});taskCount=1}} | ConvertTo-Json -Depth 6 -Compress
  $operation = Invoke-RestMethod -Method Post -Headers $headers -TimeoutSec 60 -ContentType 'application/json' `
    -Uri "https://run.googleapis.com/v2/projects/$Project/locations/$Region/jobs/${Job}:run" -Body $body
  $operationUri = 'https://run.googleapis.com/v2/'+$operation.name
  Write-Output ('Started '+$operation.name)
  $deadline = (Get-Date).AddMinutes(10)
  while (-not $operation.done -and (Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 5
    $operation = Invoke-RestMethod -Headers $headers -TimeoutSec 60 -Uri $operationUri
  }
  if (-not $operation.done) { throw "Still running. Inspect $operationUri before retrying; do not launch overlapping jobs." }
  if ($operation.error -or $operation.response.succeededCount -ne 1) {
    throw ('Binding did not succeed. Inspect the private job execution logs: '+$operation.name)
  }
  Write-Output ('Succeeded: '+$operation.response.name)
  Write-Output "Reload /console and sign in again. Membership: $Handle."
} finally {
  Remove-Variable token,headers,user,users,lookup,body -ErrorAction SilentlyContinue
}
