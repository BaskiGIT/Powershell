New-Alias -Name ver -Value Get-TMVersion -ErrorAction SilentlyContinue

Function Get-TMVersion {
    $OS = Get-CimInstance -ClassName Win32_OperatingSystem
    if ($OS.Name -like 'Microsoft Windows*')
    {
        $Version = "$($OS.Name) " + "$($os.Version)"
    }
    Write-Output -Verbose $Version
}