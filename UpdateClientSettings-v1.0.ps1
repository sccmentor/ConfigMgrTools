#   Notes 
#   Script name: UpdateClientSettings-v1.0.ps1
#   Author:      Paul Winstanley  @SCCMentor
#   DateCreated: 26/03/2015
#   Version: v1.0
#
#   Variables Required:
#
#   $SiteServer = hostname of the ConfigMgr Site Server
#   $SiteCode = Three digit Site Code

$null=[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$null=[reflection.assembly]::LoadWithPartialName("System.Drawing")
$null=[reflection.assembly]::LoadWithPartialName("System.Data")

#Set ConfigMgr site info
$SiteServer = "<Enter Site Server>"
$SiteCode = "<Enter Site Code>"

$DataGridView = new-object System.windows.forms.DataGridView
$DataGridViewSCEP = new-object System.windows.forms.DataGridView

#Create array of client settings for Client Settings
$array= new-object System.Collections.ArrayList
$data=@(get-WmiObject -ComputerName $SiteServer -Class SMS_ClientSettings -Namespace root/SMS/site_$SiteCode | Select Name,Priority | Sort-Object Priority)
$array.AddRange($data)
$Datagridview.DataSource = $array

#Create array of client settings for SCEP
$arraySCEP= new-object System.Collections.ArrayList
$dataSCEP=@(get-WmiObject -ComputerName $SiteServer -Class SMS_AntimalwareSettings -Namespace root/SMS/site_$SiteCode | Select Name,Priority | Sort-Object Priority)
$arraySCEP.AddRange($dataSCEP)
$DatagridviewSCEP.DataSource = $arraySCEP

#Initialise Form and DataGrid Settings
$form = new-object System.Windows.Forms.Form
$form.Size = new-object System.Drawing.Size 800,700
$Form.MaximizeBox = $false
$Form.FormBorderStyle = 'Fixed3D'
$Form.Text = "Update Client Settings Priority Tool now with added SCEP- v1.0" #window description
$System_Drawing_Size = New-Object System.Drawing.Size
$DataGridView.Location = '30,50'
$DataGridView.Size = New-Object System.Drawing.Size(720,300)
$DataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$DataGridView.AllowUserToAddRows = $false
$DataGridView.AllowUserToDeleteRows = $false

#Initialise Form and DataGrid Settings for SCEP
#$System_Drawing_SizeSCEP = New-Object System.Drawing.Size
$DataGridViewSCEP.Location = '30,400'
$DataGridViewSCEP.Size = New-Object System.Drawing.Size(720,200)
$DataGridViewSCEP.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$DataGridViewSCEP.AllowUserToAddRows = $false
$DataGridViewSCEP.AllowUserToDeleteRows = $false


#Create Update Button for Client Settings
$ButtonGet = New-Object System.Windows.Forms.Button
$ButtonGet.Location = New-Object System.Drawing.Size(650,10)
$ButtonGet.Size = New-Object System.Drawing.Size(100,35)
$ButtonGet.Text = "Update Client Settings"

#Create Update Button for SCEP
$ButtonGetSCEP = New-Object System.Windows.Forms.Button
$ButtonGetSCEP.Location = New-Object System.Drawing.Size(650,358)
$ButtonGetSCEP.Size = New-Object System.Drawing.Size(100,35)
$ButtonGetSCEP.Text = "Update SCEP Settings"

#Update Client Settings
$ButtonGet.Add_Click({ 
    $Duplicates = $DataGridView.DataSource.Priority | group -noelement | sort count -descending | Where-Object {$_.count -gt 1} 
    If ($Duplicates -ne $NULL) {
        [System.Windows.Forms.MessageBox]::Show("Duplicate Priority. Check Values")
    }
    
    else {
        foreach ($Item in $Datagridview.DataSource) {
            
            if ([int]$Item.Priority -ge 10000) {
                $TooHigh = $item.Name
                [System.Windows.Forms.MessageBox]::Show("Client Setting higher than 10000 will be ignored: $TooHigh. Please re-enter with a lower priority.")
            }
            else {
                $ClientSettingName = $Item.Name
                $ClientSettingPriority = $Item.Priority
                $UpdateClientSettings = (Get-WmiObject -ComputerName $SiteServer -Class SMS_ClientSettings -Namespace root/SMS/site_$SiteCode -Filter "Name='$ClientSettingName'")
                $UpdateClientSettings.Priority = $ClientSettingPriority
                $UpdateClientSettings.Put()
            }
         }
    [System.Windows.Forms.MessageBox]::Show("Client Settings Updated")
    }
})

#Update SCEP Settings
$ButtonGetSCEP.Add_Click({ 
    $Duplicates = $DataGridViewSCEP.DataSource.Priority | group -noelement | sort count -descending | Where-Object {$_.count -gt 1} 
    If ($Duplicates -ne $NULL) {
        [System.Windows.Forms.MessageBox]::Show("Duplicate Priority. Check Values")
    }
    else {
        foreach ($Item in $DatagridviewSCEP.DataSource) {
            if ([int]$Item.Priority -ge 10000) {
                $TooHigh = $item.Name
                [System.Windows.Forms.MessageBox]::Show("Client Setting higher than 10000 will be ignored: $TooHigh. Please re-enter with a lower priority.")
            }
            else {
                $SCEPSettingName = $Item.Name
                $SCEPSettingPriority = $Item.Priority
                $UpdateSCEPSettings = (Get-WmiObject -ComputerName $SiteServer -Class SMS_AntimalwareSettings -Namespace root/SMS/site_$SiteCode -Filter "Name='$SCEPSettingName'")
                $UpdateSCEPSettings.Priority = $SCEPSettingPriority
                $UpdateSCEPSettings.Put()
            }
        }
    [System.Windows.Forms.MessageBox]::Show("SCEP Settings Updated")
    }
})

#Create form view
$form.Controls.Add($DataGridView)
$form.Controls.Add($DataGridViewSCEP)
$form.topmost = $true
$form.Controls.Add($ButtonGet)
$form.Controls.Add($ButtonGetSCEP)
$null = $form.showdialog()