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
ForEach ($RemoteProfile in $UserProfileObjects)
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
