#Requires -Version 5.1
$ErrorActionPreference='Stop'
$installer=Join-Path $PSScriptRoot 'tools\install-windows.ps1'
if(-not(Test-Path -LiteralPath $installer)){
  throw "找不到 $installer。请进入包含 CodexStartup.exe 的仓库目录后再运行。"
}
& $installer
