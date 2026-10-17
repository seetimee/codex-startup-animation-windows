param([string]$ProfileDirectory='', [switch]$NoDialog, [switch]$OpenSettings)
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
if($ProfileDirectory){$ProfileDirectory=[IO.Path]::GetFullPath($ProfileDirectory)}
$logDirectory=Join-Path $env:LOCALAPPDATA 'CodexStartupWindows'
New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null
$logFile=Join-Path $logDirectory 'launcher.log'
$lock=[Threading.Mutex]::new($false,'Local\CodexStartupWindowsLauncher')
$locked=$false
function Write-Log([string]$text){Add-Content -LiteralPath $logFile -Value ((Get-Date -Format s)+' '+$text) -Encoding UTF8}
try{
    try{$locked=$lock.WaitOne(0)}catch [Threading.AbandonedMutexException]{$locked=$true}
    if(-not $locked){exit 0}
    $package=Get-AppxPackage -Name 'OpenAI.Codex' | Sort-Object Version -Descending | Select-Object -First 1
    if(-not $package){throw '没有找到当前用户安装的官方 Codex。请先安装并打开官方应用。'}
    if($package.Publisher -ne 'CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'){throw '应用包发布者与已验证的官方 Codex 不一致。'}
    $appPath=Join-Path $package.InstallLocation 'app'
    $executable=Join-Path $appPath 'ChatGPT.exe'
    if(-not(Test-Path -LiteralPath $executable)){throw ('官方应用缺少运行文件：'+$executable)}
    $exeSignature=Get-AuthenticodeSignature -LiteralPath $executable
    if($exeSignature.Status -ne 'Valid'){throw ('运行文件签名验证失败：'+$executable)}
    if($exeSignature.SignerCertificate.GetNameInfo([Security.Cryptography.X509Certificates.X509NameType]::SimpleName,$false) -ne 'OpenAI OpCo, LLC'){throw '应用签名不是预期的 OpenAI 发布者。'}
    # WindowsApps 内 node.exe 常带包身份条件 ACL，外部启动器会“拒绝访问”。
    # 优先试官方包内路径，失败则回退到本机 Codex runtime / PATH 上的 node。
    function Test-NodeExe([string]$path){
        if(-not $path -or -not(Test-Path -LiteralPath $path)){return $false}
        try{
            $probe=Start-Process -FilePath $path -ArgumentList @('-v') -WindowStyle Hidden -Wait -PassThru -ErrorAction Stop
            return ($probe.ExitCode -eq 0)
        }catch{return $false}
    }
    $nodeCandidates=@()
    $nodeCandidates+=Join-Path $appPath 'resources\cua_node\bin\node.exe'
    $runtimeRoot=Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\runtimes\cua_node'
    if(Test-Path -LiteralPath $runtimeRoot){
        $nodeCandidates+=@(Get-ChildItem -LiteralPath $runtimeRoot -Recurse -Filter 'node.exe' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | ForEach-Object {$_.FullName})
    }
    $pathNode=(Get-Command node -ErrorAction SilentlyContinue | Select-Object -First 1).Source
    if($pathNode){$nodeCandidates+=$pathNode}
    $node=$null
    foreach($candidate in ($nodeCandidates | Select-Object -Unique)){
        if(Test-NodeExe $candidate){$node=$candidate;Write-Log ('Using node: '+$node);break}
    }
    if(-not $node){throw '找不到可执行的 Node。WindowsApps 内官方 node 可能因包权限无法外调；请确认已打开过官方 Codex，或本机 PATH 已有 node。'}
    $sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $processes=@(Get-CimInstance Win32_Process -Filter "Name='ChatGPT.exe'" | Where-Object {$_.ExecutablePath -eq $executable -and $_.CommandLine -notmatch '--type='})
    $existing=$processes | Where-Object {
        if($ProfileDirectory){$_.CommandLine -like ('*'+$ProfileDirectory+'*')}
        else{$_.CommandLine -notmatch '--user-data-dir='}
    } | Where-Object {(Invoke-CimMethod -InputObject $_ -MethodName GetOwnerSid).Sid -eq $sid} | Select-Object -First 1
    if($existing){
        if($OpenSettings){
            $sessionPath=Join-Path $logDirectory 'session.json'
            $session=$null
            try{$session=Get-Content -LiteralPath $sessionPath -Raw -ErrorAction Stop | ConvertFrom-Json}catch{}
            if(-not $session -or $session.pid -ne $existing.ProcessId -or $session.packageFullName -ne $package.PackageFullName -or $session.port -lt 1 -or $session.port -gt 65535){throw 'Codex 正在运行，但本次未从动画入口启动。请保存工作，在菜单或托盘中彻底退出 Codex，再打开「Codex Startup Windows 设置」。'}
            $result=& $node (Join-Path $root 'extension\windows.mjs') --port $session.port --pid $existing.ProcessId --exe $executable --sid $sid --package $package.PackageFullName --settings 2>&1
            $settingsExit=$LASTEXITCODE
            foreach($line in $result){Write-Log ([string]$line)}
            if($settingsExit -ne 0){throw ('设置打开失败：'+($result -join [Environment]::NewLine))}
            if(-not $ProfileDirectory){Add-Type -Path (Join-Path $PSScriptRoot 'Activation.cs');[PackageStartup]::Launch($package.PackageFamilyName+'!App','') | Out-Null}
            exit 0
        }
        Add-Type -Path (Join-Path $PSScriptRoot 'Activation.cs')
        $activatedPid=[PackageStartup]::Launch($package.PackageFamilyName+'!App','')
        Write-Log ('Existing official window activated; pid='+$existing.ProcessId)
        exit 0
    }
    $portListener=[Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback,0)
    $portListener.Start();$port=$portListener.LocalEndpoint.Port;$portListener.Stop()
    $arguments='--remote-debugging-address=127.0.0.1 --remote-debugging-port='+$port
    if($ProfileDirectory){
        $profilePath=[IO.Path]::GetFullPath($ProfileDirectory)
        $arguments+=' --user-data-dir="'+$profilePath+'" --no-first-run'
    }
    Add-Type -Path (Join-Path $PSScriptRoot 'Activation.cs')
    $officialPid=[PackageStartup]::Launch($package.PackageFamilyName+'!App',$arguments)
    @{pid=$officialPid;port=$port;packageFullName=$package.PackageFullName} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $logDirectory 'session.json') -Encoding UTF8
    Write-Log ('Launching official app with MSIX identity; pid='+$officialPid+'; port='+$port+'; package='+$package.Version)
    $nodeArgs=@((Join-Path $root 'extension\windows.mjs'),'--port',[string]$port,'--pid',[string]$officialPid,'--exe',$executable,'--sid',$sid,'--package',$package.PackageFullName)
    if($OpenSettings){$nodeArgs+='--settings'}
    $result=& $node @nodeArgs 2>&1
    $exitCode=$LASTEXITCODE
    foreach($line in $result){Write-Log ([string]$line)}
    if($exitCode -ne 0){throw ('动画接入失败。'+[Environment]::NewLine+($result -join [Environment]::NewLine))}
}catch{
    Write-Log ('ERROR: '+$_.Exception.Message)
    if(-not $NoDialog){
        Add-Type -AssemblyName System.Windows.Forms
        [Windows.Forms.MessageBox]::Show(($_.Exception.Message+[Environment]::NewLine+[Environment]::NewLine+'官方安装包未修改。请完全退出后从官方图标重新打开。'+[Environment]::NewLine+'日志：'+$logFile),'Codex 启动动画',[Windows.Forms.MessageBoxButtons]::OK,[Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
    }
    exit 1
}finally{if($locked){$lock.ReleaseMutex()};$lock.Dispose()}
