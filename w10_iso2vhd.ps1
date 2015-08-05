<#
    $filename = w10_iso2vhd.ps1
    $author =   T. Butz 
    $version =  2015.07.29
    $url =      'www.thorsten-butz.de'; $twitter = $adn = '@thorstenbutz'

    This demo scripts creates a "Windows 10 Pro" Hyper-V Gen2 VM without attendence. 
    It utilizes "Convert-WindowsImage" from Technet Gallery to create a VHDX from
    the regular ISO file without the need for a standard setup. 

    Furthermore the script implants an unattended file to get rid of setup dialogues. 
    You may want to have a brief look into the unattend.xml: 
    the example file enables German keyboard layout and a few optional 
    "First logon commands" to simplify your customization. 

    Required files (will be downloaded by the script):
    a) Convert-WindowsImage, tested with version 10 from 2015-06-19 
       https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f

    b) Unattended file:
       http://www.thorsten-butz.de/public/w10oobe1_unattend.xml 

    Required file (NOT downloaded by the script): 
    c) Windows 10 ISO, grab it from MSDN or create your own with Microsofts
       Media Creation Tool: http://go.microsoft.com/fwlink/p/?LinkId=616447
       => Put the ISO file somewhere below "c:\iso2vhd" and check the 
          file name in line 34!
#>


# Step 1: Getting things ready 
[string]$vm      =  'w10pro_iso2vhd'
[string]$iso2vhd =  'c:\iso2vhd'
[string]$w10iso  =  'en_windows_10_multiple_editions_x64_dvd_6846432.iso'
[string]$uri1    =  'https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f/file/59237/7/Convert-WindowsImage.ps1'
[string]$uri2    =  'http://www.thorsten-butz.de/public/w10oobe1_unattend.xml'
[string]$dst1    =  "$iso2vhd\Convert-WindowsImage.ps1"
[string]$dst2    =  "$iso2vhd\unattend.xml"

if (!(test-path c:\iso2vhd)) { mkdir $iso2vhd }
if (!(test-path $dst1)) { Invoke-WebRequest -Uri $uri1 -OutFile $dst1 }
if (!(test-path $dst2)) { Invoke-WebRequest -Uri $uri2 -OutFile $dst2 }

# Step 2: We need the ISO file 
$iso = Get-ChildItem -Path $iso2vhd -Filter $w10iso -Recurse | Select-Object -First 1 -ExpandProperty Fullname
if (!$iso) { "Copy the Windows 10 ISO file into `"$iso2vhd`" folder and run the script again!" ; return }

# Step 3: Check Hyper-V 
try { Get-VMHost | Out-Null} catch { 'Install Hyper-V and run script again!' ; return }
(Get-VMHost).VirtualHardDiskPath

# Step 4: Create VHDX
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))) {
  'Converting the ISO to a VHDX file requires elevated rights. Please restart script "as administrator"!' ; return
}

$vhdx = (Get-VMHost).VirtualHardDiskPath + "\$vm.vhdx"
. $dst1 # Load function
Convert-WindowsImage -SourcePath $iso -VHDType Dynamic -VHDPartitionStyle GPT -SizeBytes 300GB -Edition 'Windows 10 Pro' -VHDFormat VHDX -VHDPath $vhdx -UnattendPath $dst2
      
# Step 5: Create (Hyper-V) VM, GEN 2    
New-VM -Name $vm -VHDPath $vhdx -MemoryStartupBytes 1GB -Generation 2 # -SwitchName $switch1 
Set-VM -Name $vm -ProcessorCount 2  
# Add-VMDvdDrive -VMName $vm -Path $iso2 
Start-VM -VMName $vm

"$vm configured .."
