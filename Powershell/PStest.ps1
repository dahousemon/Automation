cls
$switcher = Get-Random 4

switch ($switcher) {

0 {Write-Host "The Number is 0" : break}
1 {Write-Host "The Number is 1" : break}
2 {Write-Host "The Number is 2" : break}
default {Write-Host "This is default"}



}