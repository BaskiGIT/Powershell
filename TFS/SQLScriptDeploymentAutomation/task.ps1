##  
    ## "Author			    :	Baskar Lingam Ramachandran"
    ## "Created Date	    :	18th May 2017"
    ## "Purpose			    :	To execute .sql scripts from a folder using sqlcmd.exe in a server using vNext TFS Release"
##

[CmdletBinding()]
Param()

Trace-VstsEnteringInvocation $MyInvocation

try
{

[string]$DBServerName = Get-VstsInput -Name DBServerName -Require
[string]$DBName = Get-VstsInput -Name DBName -Require
[string]$ScriptPath = Get-VstsInput -Name ScriptPath -Require
[string]$OutputPath = Get-VstsInput -Name OutputPath -Require
[string]$RunAsUser = Get-VstsInput -Name RunAsUser -Require
[string]$ShowOutput = Get-VstsInput -Name ShowOutput -AsBool -Require

function Show-OutputSingle
{
    param([string] $OutputPath)

    Write-Host "`t`t Will show outout files from this folder $OutputPath`r`n" -ForegroundColor Cyan

    if (Test-Path $OutputPath -PathType Leaf)
    {
        $content = Get-Content $OutputPath
        Write-Host "`t`tThe output is : $OutputPath`r`n" -ForegroundColor Cyan
        $content
    }
}

function Show-OutputMultiple
{
    param([string] $OutputPath)

    if(Test-Path $OutputPath -PathType Container)
    {
        Write-Host "`t`t Will show content of the output file $OutputPath`r`n" -ForegroundColor Cyan

        foreach ($file in gci $OutputPath -File -Recurse -Filter "*.txt")
        {
            $content = Get-Content $file.FullName
            Write-Host "`t`t The output is : $($file.FullName)`r`n" -ForegroundColor Cyan
            $content
        }
    }
}


function Execute-MultipleSQLScripts
{
    ## Executing multiple SQL Scripts

    $sqlcmdpath = gcm sqlcmd | Select Path

    $sqlcmdpathString = $sqlcmdpath.Path.ToString()

    if (Test-Path $sqlcmdpathString)
    {
        Write-Host "`t`t The SQL scripts will be executed in the server :: $DBServerName on Database :: $DBName`r`n" -ForegroundColor Cyan

        Write-Host "`t`t--------------Executing SQLCMD-----------------`r`n"        

        foreach ($file in gci $ScriptPath -File -Recurse)
        {
            $childPath = [IO.Path]::GetFileName($file) + ".txt"

            $outputPath_txt = Join-Path -Path $OutputPath -ChildPath $childPath

            $file = $file.FullName

            Write-Host "`t`t Executing the command SQLCMD -S $DBServerName -d $DBName -i $file -o $outputPath_txt for user $RunAsUser`r`n" -ForegroundColor Cyan

            Write-Host "`t`t.\RunAsUser.exe /user:$RunAsUser $sqlcmdpathString `"-S $DBServerName -d $DBName -i $file -o $outputPath_txt`r`n" -ForegroundColor Cyan


            .\RunAsUser.exe /user:$RunAsUser $sqlcmdpathString "-S $DBServerName -d $DBName -i $file -o $outputPath_txt"


        }


        Write-Host "`t`t--------------SQLCMD execution is complete-----------------`r`n"
        
        if($ShowOutput -eq "true")
        {
            Write-Host "`t`t--------------OUTPUT OF EXECUTION-----------------`r`n"
            Show-OutputMultiple $OutputPath
        }
   }
}

function Execute-SingleSQLScript
{
    ## Executing a single SQL Script

    $sqlcmdpath = gcm sqlcmd | Select Path

    $sqlcmdpathString = $sqlcmdpath.Path.ToString()

    if (Test-Path $sqlcmdpathString)
    {
        Write-Host "`t`t The SQL scripts will be execute in the server : $DBServerName `r`n" -ForegroundColor Cyan

        Write-Host "`t`t--------------Executing SQLCMD-----------------`r`n"        

        $file = $ScriptPath
        
        $childPath = [IO.Path]::GetFileName($file) + ".txt"

        $outputPath_txt = Join-Path -Path $OutputPath -ChildPath $childPath

        Write-Host "`t`t Executing the command SQLCMD -S $DBServerName -d $DBName -i $file -o $outputPath_txt for user $RunAsUser`r`n" -ForegroundColor Cyan

        Write-Host "`t`t.\RunAsUser.exe /user:$RunAsUser $sqlcmdpathString `"-S $DBServerName -d $DBName -i $file -o $outputPath_txt`r`n" -ForegroundColor Cyan


        .\RunAsUser.exe /user:$RunAsUser $sqlcmdpathString "-S $DBServerName -d $DBName -i $file -o $outputPath_txt"


        Write-Host "`t`t--------------SQLCMD execution is complete-----------------`r`n"

        if($ShowOutput -eq "true")
        {
            Write-Host "`t`t--------------OUTPUT OF EXECUTION-----------------`r`n"
            Show-OutputSingle $outputPath_txt
        }
   }
}

function Get-NumberOfScripts
{
    ## Getting number of scripts present in the folder

    $count = gci $ScriptPath -File | where {[IO.Path]::GetExtension($_.FullName) -eq ".sql"}
    $countOfFiles = $count.Count

    if ($countOfFiles -gt 0)
    {
        Write-Host "`t`t The number of scripts present is $countOfFiles`r`n" -ForegroundColor Cyan
        Execute-MultipleSQLScripts
    }
    else
    {
        Write-Warning "There are no .sql files present in the folder. So there will be no execution."
    }

}

#########################

## VALIDATING OUTPUT PATH

if (Test-Path $OutputPath -PathType Container)
{
    Write-Host "`t`t The given output path $OutputPath is an existing folder. Output will be written to this folder`r`n" -ForegroundColor Cyan
}

else
{
    $OutputPath = [IO.Path]::GetDirectoryName($OutputPath)
    if (Test-Path $OutputPath -PathType Container)
    {
        Write-Host "`t`t The given output path is a file. But the output/s will be written to the containing folder.`r`n" -ForegroundColor Cyan
        Write-Host "`t`t Output will be written to the folder $OutputPath.`r`n" -ForegroundColor Cyan
    }
    else
    {
        Write-Error "`t`t $OutputPath does not exist. Please provide either an existing folder or file in the server as input for this field OutputPath.`r`n"
    }    
}

#########################

if (Test-Path $ScriptPath -PathType Container)
{
    Write-Host "`t`t The given path $ScriptPath is a valid folder`r`n" -ForegroundColor Cyan
    Get-NumberOfScripts
}

elseif (Test-Path $ScriptPath -PathType Leaf)
{
    if ([IO.Path]::GetExtension($ScriptPath) -eq ".sql")
    {
        Write-Host "`t`t The given path $ScriptPath is an existing SQL script. Only this script will be executed.`r`n" -ForegroundColor Cyan
        Execute-SingleSQLScript
    }
    else
    {
        Write-Warning "The given path $ScriptPath is not a SQL script. It will (can) not be executed."
    }
}
else
{
    Write-Error "The given folder $ScriptPath is not a folder. Specify"
}

}
finally
{
Trace-VstsLeavingInvocation $MyInvocation
}
