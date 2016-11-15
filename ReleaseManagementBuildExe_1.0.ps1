# Author : Baskar Lingam Ramachandran
# Date : 18th Oct 2016
# Purpose : Execute a Release 
" This script will trigger a Release using Release parameter of ReleaseManagementBuild.exe "
<#param([string] $ReleaseTempName, [string] $BuildNumber, [string] $StageName, [string] $BuildDefName)
#>
$RMBuildExePath = Get-WmiObject win32_service | ?{$_.Name -like "*Deployment*"} | select PathName
$RMBuildExePathString = $RMBuildExePath.PathName
# $RMBuildExePath = "D:\Apps\Microsoft Visual Studio 14.0\Release Management"
# $RMString = $RMBuildExePath.ToString()
[string[]]$split = $RMBuildExePathString.Split("\")
$split
$arrayLength = $split.Count
[string]$RMBuildExePathFormation = [string]::Empty
for ($i = 0; $i -lt $arrayLength-2; $i++)
{
    if ($i -eq 0)
    {
        $RMBuildExePathFormation = $split[$i].Replace("`"","")
    }
    else
    {
        $RMBuildExePathFormation = Join-Path $RMBuildExePathFormation $split[$i]
    }
}
$RMBuildExePathFormation
$RMBuildExePathFormation = [IO.Path]::Combine($RMBuildExePathFormation, 'Client', 'bin', 'ReleaseManagementBuild.exe')
<#$RMBuildExePathFormation = Join-Path $RMBuildExePathFormation Client
$RMBuildExePathFormation = Join-Path $RMBuildExePathFormation bin
$RMBuildExePathFormation = Join-Path $RMBuildExePathFormation ReleaseManagementBuild.exe
$RMBuildExePathFormation
#>
$RMBuildExePathFormation
Test-Path -LiteralPath $RMBuildExePathFormation
[System.IO.File]::Exists($RMBuildExePathFormation)
<#Test-Path $RMBuildExePathFormation -IsValid
$split
$Artifact = "`"" + "\\ServerName\BuildDrops\" + $BuildDefName + "\" + $BuildNumber + "`""
& "$RMBuildExePath\Client\bin\ReleaseManagementBuild.exe" release -rt $ReleaseTempName -pl $Artifact -ts $StageName
#>
#[IO.Path]::Combine($RMBuildExePathFormation, 'Client', 'bin', 'ReleaseManagementBuild.exe')
