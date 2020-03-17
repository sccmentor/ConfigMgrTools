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



