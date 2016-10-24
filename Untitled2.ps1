<#$process = get-process -Name winword
$process
$process.Company#>
set-location E:\Puppet
gci | select-object Name, Length
Get-ChildItem | Where-Object {$_.Length -gt 10kb} | Sort-Object Length | Format-Table -Property Name, Length -AutoSize

get-psprovider
Get-PSDrive
Get-PSSnapin -Registered
Add-PSSnapin WDeploySnapin3.0

$array = 1..5
$array -contains 30


:label foreach ($var in 1..3)
{
    "`$var is $var"
    foreach ($num in 4..6)
    {
        "`t`$num is $num"
        continue label
    }
}