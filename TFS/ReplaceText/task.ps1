[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
    Import-VstsLocStrings "$PSScriptRoot\task.json"

    # Get the inputs.
    
	[string]$PathToFile = Get-VstsInput -Name PathToFile
    [string]$TextToReplace = Get-VstsInput -Name TextToReplace
    
	Write-Host "`t`tThe PathToFile received in the script is $PathToFile.`r`n" -ForegroundColor DarkGray
	Write-Host "`t`tThe TextToReplace received in the script is $TextToReplace.`r`n" -ForegroundColor DarkGray
	
	$typeValue = $TextToReplace.GetType()
	
    Write-Host "`t`tThe Type of multiline input is $typeValue.`r`n" -ForegroundColor DarkGray

    $TextToReplace.Split("`n") | ForEach-Object { $_.Trim()} | ForEach-Object { $_.Split(":") } | ForEach-Object { $_.Trim() } | ForEach-Object { Write-Host "`t`t" $_ }
	
	[string[]] $lines = $TextToReplace.Split("`n")
	
	$countOfArray = $lines.Count

    $dict = @{}

    $iterativeCount = 0
	
    for ($i=0; $i -lt $countOfArray; $i++)
    {
        [string[]] $linesSplit = $lines[$i].Split(":")

        $countOfSplitArray = $linesSplit.Count

        if ($countOfSplitArray -eq 2) # Making sure only a single variable and value is defined in a line
        {
            $key =  $linesSplit[0].Trim()
            $value = $linesSplit[1].Trim()

            $dict.Add($key,$value)
        }
        else
        {
            Write-Error "You have not defined an input in the format variable:value... Kindly take a look and retry after correcting"
        }
    }

	Write-Host "`t`tThe number of pairs of variable:value is $countOfArray`r`n" -ForegroundColor DarkGray

    [string] $text = [System.IO.File]::ReadAllText($PathToFile)

    foreach ($h in $dict.GetEnumerator())
    {
        Write-Host "`t`t Variable is $($h.Name) ::: Value is $($h.Value)`r`n" -ForegroundColor DarkGray
        $MatchesKey = Select-String -InputObject $text -Pattern "$($h.Name)" -AllMatches
        $countOfMatch = $MatchesKey.Matches.Count        
        Write-Host "`t`t Count of $($h.Name) in the file is $countOfMatch"

        if ($countOfArray -gt 0)
        {
            $iterativeCount++
        }

    }

    

    ## Updating the file

    Write-Host "`t`tValue of iterative counter is $iterativeCount" -ForegroundColor Cyan

    if ($iterativeCount -gt 0)
    {
        foreach ($t in $dict.GetEnumerator())
        {
            (Get-Content $PathToFile) | % {$_ -replace $($t.Name), $($t.Value)} | Set-Content $PathToFile
        }

        Write-Host "`t`t The file $PathToFile is updated.`r`n" -ForegroundColor Green
    }

        
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
