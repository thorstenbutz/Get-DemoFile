<#
$author = T. Butz, 
$version = 2013.04.26
$url = 'www.thorsten-butz.de'; $twitter = $adn = '@thorstenbutz'

Short demo script to split a displayname into "givenName","sn" and "samaccountname".
$displaynames must be separated by a single blank space or comma (with or without an additional space).
Umlaute and "ß" are converted for samAccountNames.
#>

function Split-DisplayName ($displayname) {

    if ($displayname -match ",") {
        $displayname = $displayname -replace " "
        $name = $displayname.Split(",")
        $sn = $name[0] -replace ","
        $givenName = $name[1]
    }
    else {
        $name = $displayname.Split(" ")
        $givenName = $name[0]
        $sn = $name[1]
    }

    $samAccountName = ($sn + $givenName.Substring(0,1) -replace "ä","ae" -replace "ö","oe" -replace "ü","ue" -replace "ß","ss").ToLower()

    $givenName
    $sn
    $samAccountName 
}

# Demo displaynames:
$displaynames = "Duck, Donald", "Mackie Mäßer", "Ümüt Özmir"

# Loop through the collection of demo displaynames:
foreach ($displayname in $displaynames) {
  $split = Split-DisplayName $displayname
  Write-Host -f yellow $displayname
  "Given name:     $($split[0])"
  "Surname:        $($split[1])"
  "Samaccountname: $($split[2])"
}
