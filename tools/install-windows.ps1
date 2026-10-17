#Requires -Version 5.1
$ErrorActionPreference='Stop'
$repo=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$package=Get-AppxPackage -Name OpenAI.Codex | Sort-Object Version -Descending | Select-Object -First 1
if(-not $package -or $package.SignatureKind -ne 'Store') {throw '请先安装 Microsoft Store 版官方 Codex。'}
$exe=Join-Path $repo 'CodexStartup.exe'
if(-not(Test-Path -LiteralPath $exe)) {throw '仓库根目录缺少 CodexStartup.exe。'}
$launch=Join-Path $repo 'windows\launch.ps1'
if(-not(Test-Path -LiteralPath $launch)) {throw '仓库缺少 windows\launch.ps1。'}
$icon=Join-Path $repo 'assets\windows-codex.ico'
$desktop=[Environment]::GetFolderPath('Desktop')
$shell=New-Object -ComObject WScript.Shell
foreach($entry in @(
  @('Codex Animation',$exe,''),
  @('Codex Image Settings',$exe,'--settings')
)) {
  $shortcutPath=Join-Path $desktop ($entry[0]+'.lnk')
  $shortcut=$shell.CreateShortcut($shortcutPath)
  $shortcut.TargetPath=$entry[1]
  $shortcut.Arguments=$entry[2]
  $shortcut.WorkingDirectory=$repo
  if(Test-Path -LiteralPath $icon){$shortcut.IconLocation=$icon+',0'}
  $shortcut.Save()
}
Write-Output 'Installed. Fully exit Codex, then open the Codex Animation desktop shortcut or CodexStartup.exe.'
