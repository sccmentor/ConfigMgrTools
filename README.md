# ConfigMgrTools
Stuff from TechNet - ported to GitHub

**1. Update Client Settings Priority in ConfigMgr 2012 - v1.0**

This script allows the bulk editing of client settings and SCEP priority via a PowerShell form. 

For further information on how to use the Tool go to https://sccmentor.wordpress.com/2015/03/26/update-client-settings-priority-tool-for-configmgr-2012-v1-0/.

To use this script the following input variables are required: 

*  **SiteCode** - Specify the site code of the ConfigMgr site.
*  **SiteServer** - Specify the site server name.

Note that duplicate entries cannot be entered and no policy value over 9999 is allowed.

Download - **UpdateClientSettings-v1.0.ps1**

**2. Adding Dynamic Machines Variables via PowerShell**

The script creates machine variables for an object in Configuration Manager from an array of Names and Values. The Names and Values must be entered into the PS file prior to executing the script.

The variables that control Names and Values are:

*  **ComputerVariablesName** - Enter the relevant machine variable name
*  **ComputerVariablesValue** - Enter the relevant machine variable value

To use this script the following input variables are required:

*  **ComputerName** - Specify the Host Name of the device. 
*  **SiteCode** - Specify the site code of the ConfigMgr site.
*  **SiteServer** - Specify the site server name.

Usage Example: **./Add-MachineVariables.ps1 -ComputerName HostName-01 -SiteServer ConfigMgr-01 -SiteCode CMR**

For more details see https://sccmentor.wordpress.com/2015/01/22/adding-dynamic-machines-variables-as-part-of-an-automated-build-using-powershell-via-configmgr-2012/

Download - **Add-MachineVariables.zip**

**3. Enumerate device targeted applications and packages**

This script enumerates applications and packages targeted at a device in ConfigMgr 2012. APPIDxx1 (for packages) and APPIDx1 (for applications) variables are created that can be used in a Task Sequence.

The script runs a remote session on the ConfigMgr site server using a service account and can enumerate apps and packages for ConfigMgr sites that manage cross-forest, trusted and untrusted and also workgroup clients.

For full details on usage https://sccmentor.wordpress.com/2015/03/12/dynamically-deploying-packages-and-applications-to-computers-using-a-task-sequence-via-powershell-in-configmgr-2012/

Note that the script can run under Windows 2008 server but requires PowerShell v3.0 and above.

Download - **DynamicAppsPackages.ps1**

**4. Remove partition as part of Windows 10 in-place upgrade with PowerShell**

This script can be added to a Windows 10 in-place upgrade Task Sequence to remove an additional, unwanted, partition such as a D: drive.

For further information on how to use the Tool go to https://sccmentor.wordpress.com/2015/05/08/remove-partition-as-part-of-windows-10-in-place-upgrade-with-powershell/.

If your extra partition is not a D: drive but another drive letter then search and replace D: within the script.

**NOTE - Use with caution on encrypted hard drives and ensure that encryption is disabled prior to running the script.**

Download - **ReconfigureDisk.ps1**
