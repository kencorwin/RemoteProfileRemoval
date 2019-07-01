$i = 0
$Profiles = @()

$Creds = Get-Credential
$HostName = Read-Host "Please enter the computer name (you may need to enter the FQDN)"

if (-not (Test-Connection -Count 1 -Quiet -ComputerName $HostName) )
    {
    Write-Host "The computer $HostName is currently un-reachable"
    pause
    #exit
    }

$UserProfileObjects = Get-WmiObject -ComputerName $HostName -ClassName Win32_UserProfile -Credential $Creds
ForEach ($RemoteProfile in ($UserProfileObjects | where { $_.Special -ne $true }))
    {
    $Object = $null
    $i++
    $UserName = ($RemoteProfile | select -ExpandProperty LocalPath).split('\')[-1]
    $ProfilePath = $RemoteProfile | select -ExpandProperty LocalPath
    $Object = New-Object PSObject -Property @{  EntryNumber = $i
                                                UserName    = $UserName
                                                ProfilePath = $ProfilePath }
    $Profiles += $Object
    }

clear
[string[]]$Menu = " Please select a profile number from below you wish to delete"
foreach ( $ProfileMenu in $Profiles ) {$Menu += "   $($ProfileMenu.EntryNumber) `t $($ProfileMenu.UserName)`r"}
$Menu
[string]$ProfileNumber = Read-Host -Prompt "You can select multiplie profiles by seperating the numbers with a comma"
$SelectedNumbers = $ProfileNumber.split(",")

foreach ( $Number in $SelectedNumbers )
    {
    if ( $Number -ge 1 -and $Number -le $i ) 
        {
        $ProfileToDel = $Profiles | where { $_.EntryNumber -eq $Number }
        $ContinueDelete = Read-Host "Are you sure you want to delete $($ProfileToDel.UserName)"
        if (
        }
    }