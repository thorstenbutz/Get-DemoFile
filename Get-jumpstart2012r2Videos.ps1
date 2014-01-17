# http://channel9.msdn.com/series/NewInWS2012R2
# http://www.microsoftvirtualacademy.com/training-courses/new-windows-server-2012-r2-jump-start

Import-Module BitsTransfer
if (!(Get-Module | ? { $_.Name -eq "BitsTransfer" })){ 'BitsTransfer not found, quitting!' ; exit }

$urls = @()
$urls += 'http://media.ch9.ms/ch9/3f64/3174a4de-5293-4561-945a-9efc16703f64/WS2012R2M01' # 1
$urls += 'http://media.ch9.ms/ch9/a0ce/c5a123af-e7a9-4b23-bf6d-b268e7b8a0ce/WS2012R2M02' # 2
$urls += 'http://media.ch9.ms/ch9/5357/08d1e507-0da3-4e6f-986c-cf06b7705357/WS2012R2M03' # 3
$urls += 'http://media.ch9.ms/ch9/d8d6/322bd3fa-cb70-4ceb-84fc-aa480de5d8d6/WS2012R2M04' # 4
$urls += 'http://media.ch9.ms/ch9/9c0f/406d18f6-d47a-42f0-9564-3d9749909c0f/WS2012R2M05' # 5
$urls += 'http://media.ch9.ms/ch9/817c/66105086-4ec8-4f93-a095-af06e7f1817c/WS2012R2M06' # 6
$urls += 'http://media.ch9.ms/ch9/e1c7/aa6eeb81-d58d-40f6-ab07-5b09092be1c7/WS2012R2M07' # 7
$urls += 'http://media.ch9.ms/ch9/757b/0516efe0-d0f8-4f87-a728-64122906757b/WS2012R2M08' # 8

@"
[1] MP3 (Audio only; 0.5 GB)
[2] MP4 (iPod, Zune HD; 3.1 GB )
[3] Mid Quality WMV (Lo-band, Mobile; 1.5 GB)
[4] High Quality MP4(iPad, PC; 6.9 GB )
[5] Mid Quality MP4(Windows Phone, HTML5; 4.8 GB )
[6] High Quality WMV(PC, Xbox, MCE; 8.7 GB)

"@

$f = Read-Host "Choose download format (from 1 to 6, see above)"

switch ($f)
  {
    1 {$suffix = '.mp3'}
    2 {$suffix = '.mp4'}
    3 {$suffix = '.wmv'}
    4 {$suffix = '_high.mp4'}
    5 {$suffix = '_mid.mp4'}
    6 {$suffix = '_Source.wmv'}
    default { 'Incorrect input, quitting!' ; exit }
      
  }

if (test-path "$home\Videos\JS2012R2\$f"){ "Path exists!" }
else { mkdir "$home\Videos\JS2012R2\$f" }

foreach ($url in $urls) {
 "Current file: " + $url + $suffix
 Start-BitsTransfer -Source ($url + $suffix) -Destination "$home\Videos\JS2012R2\$f"
}
