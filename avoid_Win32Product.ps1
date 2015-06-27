# Function(s)
function avoidWin32Product {

    # Reference: 
    # http://blogs.technet.com/b/heyscriptingguy/archive/2011/11/13/use-powershell-to-quickly-find-installed-software.aspx

    $array = @()
    [array]$computers += $args

    [array]$computers.gettype()

    foreach($computer in $computers){
    
        if ($computer -eq 'localhost') {  $computer = hostname.exe }

        #Define the variable to hold the location of Currently Installed Programs
        $UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 

        #Create an instance of the Registry Object and open the HKLM base key
        $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computer) 

        #Drill down into the Uninstall key using the OpenSubKey Method
        $regkey=$reg.OpenSubKey($UninstallKey) 

        #Retrieve an array of string that contain all the subkey names
        $subkeys=$regkey.GetSubKeyNames() 

        #Open each Subkey and use GetValue Method to return the required values for each
        foreach($key in $subkeys){

            $thisKey=$UninstallKey+"\\"+$key 
            $thisSubKey=$reg.OpenSubKey($thisKey) 
            $obj = New-Object PSObject
            $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computer
            $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
            $obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
            $obj | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation"))
            $obj | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher"))
            $array += $obj
        } 
    }

    $array | Where-Object { $_.DisplayName }
 
 }

avoidWin32Product localhost
