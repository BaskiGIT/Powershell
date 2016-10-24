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
        $tempvar = $split[$i].Split("`"")
        $RMBuildExePathFormation = $split[$i]
    }
    else
    {
        $RMBuildExePathFormation = $RMBuildExePathFormation + "\" + $split[$i]
    }
}
$RMBuildExePathFormation
$RMBuildExePath = $RMBuildExePathFormation + "\Client\bin\ReleaseManagementBuild.exe" + "`""
$RMBuildExePath
Test-Path -LiteralPath $RMBuildExePath
[System.IO.File]::Exists($RMBuildExePath)
<#Test-Path $RMBuildExePathFormation -IsValid
$split
$Artifact = "`"" + "\\icp005dd\BuildDrops\" + $BuildDefName + "\" + $BuildNumber + "`""
& "$RMBuildExePath\Client\bin\ReleaseManagementBuild.exe" release -rt $ReleaseTempName -pl $Artifact -ts $StageName
#>