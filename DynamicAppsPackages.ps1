#   Notes 
#   Script name: DynamicAppsPackages.ps1
#   Author:      Paul Winstanley  @SCCMentor
#   Inspired by code created by Peter van der Woude at http://www.petervanderwoude.nl/post/install-computer-targeted-application-during-os-deployment-via-powershell-and-configmgr-2012/
#   DateCreated: 16/02/2015
#
#   Variables description:
#
#   $ResourceName = local hostname of the device running the script
#   $password = password of service account running the app/pack enumeration for the device
#   $cred = Creates a PSCredential object of username/password that will run the remote session on behalf of the device
#   $CountPack = counter for package enumeration
#   $CountApp = counter for app enumeration
#   $SiteCode = ConfigMgr site for the environment   
#   $SiteServer = ConfigMgr site server hostname for the environment
#   $Container = Container Node in ConfigMgr that stores all the application and package deployment collections
#   $PackageEnumerate = Array to store all packages in the remote session
#   $ApplicationEnumerate = Array to store all applications in the remote session
#   $localPackages = Variable to store all packages when back in local session before passing to Task Sequence
#   $localApplications = Variable to store all packages when back in local session before passing to Task Sequence
#
#

$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$password = $tsenv.Value("svcaccpassword")
$ResourceName = $env:computername
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList @("<domain\username>",(ConvertTo-SecureString -String $password -AsPlainText -Force))
$CountPack = 1
$CountApp = 1

$ScriptBlockContent = {

  param ($ResourceName)
  $SiteCode = "<sitecode>"
  $SiteServer = "<site server>"
  $Container = "Application Deployment"
  Write-Host "$ResourceName"
  $PackageEnumerate = @()
  $ApplicationEnumerate = @()

  $ContainerNodeId = (Get-WmiObject -ComputerName $SiteServer -Class SMS_ObjectContainerNode -Namespace root/SMS/site_$SiteCode -Filter "Name='$Container' and ObjectTypeName='SMS_Collection_Device'").ContainerNodeId
  $CollectionIds = (Get-WmiObject -ComputerName $SiteServer -Namespace root/SMS/site_$SiteCode -Query "SELECT fcm.* FROM SMS_FullCollectionMembership fcm, SMS_ObjectContainerItem oci WHERE oci.ContainerNodeID='$ContainerNodeId' AND fcm.Name='$ResourceName' AND fcm.CollectionID=oci.InstanceKey").CollectionId

     if ($CollectionIds -ne $null) {
        foreach ($CollectionId in $CollectionIds) {
            $ApplicationNames = (Get-WmiObject -ComputerName $SiteServer -Class SMS_ApplicationAssignment -Namespace root/SMS/site_$SiteCode -Filter "TargetCollectionID='$CollectionId' and OfferTypeID='0'").ApplicationName            
            $AdvertisementDetails = Get-WmiObject -ComputerName $SiteServer -Class SMS_AdvertisementInfo -Namespace root/SMS/site_$SiteCode -Filter "CollectionID='$CollectionID' and PackageType='0'"  

            if ($AdvertisementDetails -ne $null) {
                
                foreach ($AdvertisementDetail in $AdvertisementDetails) {
                     $PackageEnumerate += ($AdvertisementDetail.PackageID+':'+$AdvertisementDetail.ProgramName)
                }
     }
              
            if ($ApplicationNames -ne $null) {
                foreach ($ApplicationName in $ApplicationNames) {
                    $ApplicationEnumerate += $ApplicationName
                }
            }
   
     }
     }

}
      



$Session = New-PSSession -ComputerName $SiteServer -Credential $cred
Invoke-Command -Session $Session -ScriptBlock $ScriptBlockContent -ArgumentList $ResourceName
$localPackages = Invoke-Command -Session $Session -ScriptBlock {$PackageEnumerate}
$localApplications = Invoke-Command -Session $Session -ScriptBlock {$ApplicationEnumerate}
$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment

            if ($localPackages -ne $null) {
                
                foreach ($Package in $localPackages) {
                     $Id = "{0:D3}" -f $CountPack
                     $AppId = "APPID$Id"
                     $TSEnv.Value($AppId) = $Package
                     Write-Host $AppId $Package 
                     $CountPack = $CountPack + 1
                }
     }

            if ($localApplications -ne $null) {
                
                foreach ($Application in $localApplications) {
                     $Id = "{0:D2}" -f $CountApp
                     $AppId = "APPID$Id"
                     $TSEnv.Value($AppId) = $Application
                     Write-Host $AppId $Application
                     $CountApp = $CountApp + 1
                }
     }

            if ($CountPack -eq "1") {
                $TSEnv.Value("SkipPackages") = "True"
                write-host "Skip Packages"
            }
            
            if ($CountApp -eq "1") {
                $TSEnv.Value("SkipApplications") = "True"
                Write-Host "Skip Applications"
            }
