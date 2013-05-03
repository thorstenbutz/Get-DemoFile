# $author = T. Butz, 
# $version = 2013.04.08
# $url = 'www.thorsten-butz.de'; $twitter = $adn = '@thorstenbutz'

<#

.SYNOPSIS
This command creates random passwords with a configurable length, honoring a blacklist.
 
.DESCRIPTION
This command creates "lab-friendly" passwords using letters A-Z (lower and uppercase) and 
numbers 0-9. You can pass a blacklist to omit any unwanted character.
Characters 'l','I','o','O','0' are omitted by default. The default length is set to 7. 
The command supports the common parameter "-verbose".

.EXAMPLE
New-TBPWGen.ps1 12 0,1,a,B
Creates a 12 digit password omitting the numbers 0 and 1 and the letters a and B.

.EXAMPLE
New-TBPWGen.ps1 -verbose
Enables verbose output for troubleshooting purposes.


.PARAMETER length
Defines the length of the random password. Default value is 7.

.PARAMETER blacklist
Defines an array of characters (comma separated). Those charactes are omitted. 
Default value is: 'l','I','o','O','0

.LINK
http://www.thorsten-butz.de
http://windowsitpro.com/blog/what-does-powershells-cmdletbinding-do
Get-Gelp Get-Random

#>

[CmdletBinding()]

param (

  [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
  [int]$length=7,   

  [Parameter(Mandatory=$false,ValueFromPipeline=$false)]
  $blacklist=@('l','I','o','O','0')

)

Function New-RandomPassword ($length,$blacklist) {

  Write-Verbose "Current blacklist: $blacklist"

  $pool1 += 65..90  | % { [char]$_ }   # upper case letters
  $pool1 += 97..122 | % { [char]$_ }   # lower case letters
  $pool1 += 0..9 
  
  $pool2 = New-Object System.Collections.ArrayList  # a standard array does NOT provide the "add"-method (see below)
      
  $pool1 | % {     
    if ($blacklist -cnotcontains "$_"){ $pool2.Add($_) | out-null } else { Write-Verbose "$_ removed!" }      
  }

  $r = [string]::Join('', (Get-Random -InputObject $pool2 -Count $length))
  return $r
    
} 
  
New-RandomPassword $length $blacklist
