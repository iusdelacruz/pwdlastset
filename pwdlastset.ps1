<#------ Determine who changed their domain password and who did not -----#>

ipmo ActiveDirectory
$ErrorActionPreference = "SilentlyContinue"
$string1 = "This script determines users who changed and didn't change their password when instructed.`n"
$string2 = "When did you last instructed users to change their password? (MM-dd-yy)"
$string3 = "`n`nC = Users who changed their password."
$string4 = "D = Users who didn't changed their password.`n"
$string5 = "Please select [C] or [D]"
$string6 = "Users who changed their password after $date"
$string7 = "Users who DID NOT changed their password after $date"
$string8 = "`nDo you want to export it as .txt file? Y/N"
$string9 = " is successfully exported. `nPlease check your desktop..."
$string10 = "`nExiting in 5.."
$string11 = "Exiting in 4.."
$string12 = "Exiting in 3.."
$string13 = "Exiting in 2.."
$string14 = "Exiting in 1.."
$string15 = "users_changedpwd.txt"
$string16 = "users_unchangedpwd.txt"
$string17 = "`nRun the script again? Y/N"

function pwdlastset() {

  Write-Host $string1

    do {

      $date = Read-Host $string2
      $current = Get-Date
      $timespan = New-TimeSpan -Start $date -End $current
      }

    until ($timespan -gt 0)

  Write-Host $string3
  Write-Host $string4

  do {

    $change = Read-Host $string5
      }
  
  until (($change -eq "C") -or ($change -eq "D"))


  if ($change -eq 'C') {
    $users = Get-ADUser -filter * -properties * | where {$_.Enabled -eq $true -and $_.PasswordLastSet -gt $date}
    $header = $string6
    $filename = $string15
  }

  else {
    $users = Get-ADUser -filter * -properties * | where {$_.Enabled -eq $true -and $_.PasswordLastSet -lt $date}
    $header = $string7
    $filename = $string16
  }

  Write-Host $header
  $users | Sort Name |ft Name,PasswordLastSet

  do {

    $export = Read-Host $string8
  }   

  until (($export -eq "Y") -or ($export -eq "N"))

  if ($export -eq 'Y') {
    $users | Sort Name | ft Name,PasswordLastSet > "$HOME\Desktop\$filename"
    Write-Host "`n$filename $string9"
  }

  do {

    $process = Read-Host $string17
    }   

  until (($process -eq "Y") -or ($process -eq "N"))

  if ($process -eq 'Y') {
    
    pwdlastset
    }

  else {

    Write-Host $string10
    Start-Sleep -Seconds 1
    Write-Host $string11
    Start-Sleep -Seconds 1
    Write-Host $string12
    Start-Sleep -Seconds 1
    Write-Host $string13
    Start-Sleep -Seconds 1
    Write-Host $string14
    Start-Sleep -Seconds 1
    Exit
    }

}

pwdlastset

Exit
