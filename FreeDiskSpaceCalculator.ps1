$FreeDiskSpace = get-wmiobject win32_logicaldisk # -Filter "DriveType='3'" | Select-Object Size, FreeSpace
$FreeDiskSpace
$FreeDiskSpace[0].FreeSpace
$count = $FreeDiskSpace.Count
$count
for($i = 0; $i -le $count; $i++)
{
    if(($FreeDiskSpace[$i].FreeSpace)/1GB > 1)
    {
        Write-Host "No alert needed"
    }
    else
    {
        $FreeDiskSpace[$i].DeviceID;($FreeDiskSpace[$i].FreeSpace)/1GB
    }
}