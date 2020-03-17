#   Notes 
#   Script name: ReconfigureDisk.ps1
#   Author:      Paul Winstanley
#   DateCreated: 07/05/2015
#
#   If you need to remove another parition than D: then replace the D: value within the script
#

$ExtraDrive = Get-WmiObject win32_logicaldisk -Filter "DeviceID ='D:'"

if ($ExtraDrive.DeviceID -eq 'D:') {
    xcopy $ExtraDrive.DeviceID c:\ /s /y > $env:temp\DataCopy.log
    $DriveLetter = $ExtraDrive.DeviceID.Trim(":")
    Remove-Partition -DriveLetter $DriveLetter -Confirm:$false
    $MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
    Resize-Partition -DriveLetter C -Size $MaxSize
}

else { write-host "No drive with that letter exists"
}