# Simple script to demonstrate password encrypting/decrypting secure strings in PowerShell
# http://blogs.msdn.com/b/besidethepoint/archive/2010/09/21/decrypt-secure-strings-in-powershell.aspx

function Decrypt-SecureString {
param(
    [Parameter(ValueFromPipeline=$true,Mandatory=$true,Position=0)]
    [System.Security.SecureString]
    $sstr
)

$marshal = [System.Runtime.InteropServices.Marshal]
$ptr = $marshal::SecureStringToBSTR( $sstr )
$str = $marshal::PtrToStringBSTR( $ptr )
$marshal::ZeroFreeBSTR( $ptr )
$str
} 

Do {$file = $env:TMP + (Get-Random) + ".txt"} while (Test-Path $file)
# "Password file: $file "

$p1 = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
# Alternatively $p1 = Read-Host "Password" -AsSecureString

# Enconding secure string:
$p2 = ConvertFrom-SecureString -SecureString $p1

# Create password file:
$p2 | Set-Content $file 

$p3 = Get-Content $file | ConvertTo-SecureString

Write-Host -ForegroundColor Yellow  "P1:" $p1
Write-Host -ForegroundColor White   "P2:" $p2
Write-Host -ForegroundColor Cyan    "P3:" (Decrypt-SecureString $p3)

# Clean up
Remove-Item $file 
