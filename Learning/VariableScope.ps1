Clear-Host
$var = 42
& {Write-Host "$var inside script block"}
Write-Host "$var outside script block"


Clear-Host
& {$var = 33; Write-Host "`$var inside script block is $var";
    Write-Host "Parent `$var inside script block is" (Get-Variable var -valueonly -Scope 1) }

# Using global and local variables
Clear-Host
$global:var = 35
& {Write-Host "Inside script block": $global:var;
    $global:var = 44;
    Write-Host "Inside script block after modification: $global:var"}
    Write-Host "Outside script block : $global:var"

# Local variable
Clear-Host
$local:var1 = 24
& {Write-Host "$local:var1"}
Write-Host "$local:var1"

# Function

function Display-FullName ($FirstName, $LastName)
{
    Write-Host "$FirstName `t $LastName"
}

Display-FullName "Baskar" "Sumathi"



function Set-Var ([ref] $varia)
{
    $varia.Value = 34
    Write-host "Inside function after modification $($varia.Value)"
}

$var22 = 55
Write-Host "Before modifying `$var22 is $var22"

Set-Var ([ref] $var22)
Write-Host "Outside function `$var22 is $var22"

function Print-PS1files
{
    begin {
        Write-Host "Printing PS1 files at $pwd"
    }
    process {
        if ($_.Name -like "*.ps1")
        {
            $ret_items = $ret_items + "`t" + $_.FullName + "`r`n"
        }
    }
    end {
        return $ret_items
    }
}

Clear-Host
pushd E:\Powershell
gci -Recurse | Print-PS1files