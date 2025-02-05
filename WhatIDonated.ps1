clear
$list = "$PSScriptRoot\Collectable(s)List.txt"

if(Test-Path $list){
    # Declaring variables
    $RawList = Get-Content $list
    [string[]]$CAT = @(); [Int16[]]$CAT_lineNum = @(0) #CAT=CollectableType
    $i = 0

    # Attaching values to variable(s)
    foreach ($line in $RawList){
        $line = $line.Trim()
        if ($line -match "-(.+):$"){
            $CAT += $matches.1
            $i++
            $CAT_lineNum += $CAT_lineNum[$i - 1]
        }
        $CAT_lineNum[$i]++
<#        elseif ($line -match "(.+)=(.+)"){
             $key = $Matches[1].Trim()
             $value = $Matches[2].Trim()
             $Tables[$CAT[$i - 1]][$key] = $value
         } #-headache #>
    }

    # User input to which list to open (loop so no need to reload the whole thing)
    while(1){
      clear
      Write-Host "This SCRIPT has been written by 'PotatoKips'" -ForegroundColor Cyan
      write-host "--------------------------------------------"
      Write-Host "1-" $CAT[0]"." -ForegroundColor Blue
      Write-Host "2-" $CAT[1]"." -ForegroundColor DarkBlue
      Write-Host "3-" $CAT[2]"." -ForegroundColor Green
      Write-Host "99- RESETti?" -ForegroundColor Red
  <#  $s = 1
      foreach ($EachCAT in $CAT){ # Use if want to make your own script
           Write-Host $s"-" $EachCAT[$s - 1]"." -ForegroundColor DarkRed
           $s++
      }#>
    Write-Host "Write the number to the list you want to load (anything else to quit): " -NoNewline; $i = Read-Host
    #list loop 'v'
    if ($i -match '[1-3]'){
        write-host "Print both donated and not donated items? (Y/N): " -NoNewline; $Temp_YN = Read-Host
        if ($Temp_YN -match 'y'){ Write-Host "Green (colored) item(s) is `"Donated`" and red is not."}

        $l = 0 # loop
      foreach($SpecItemS in $RawList[$CAT_lineNum[$i - 1]..($CAT_lineNum[$i])]){
        if($CAT_lineNum[$i - 1] -eq $CAT_lineNum[$i]){ break }
        elseif($l -eq 4){ write-host ""; $l = 0 } #Not related 'else(if)', but it won't execute if 'if' does anyway.
        if($SpecItemS -match '(.+)=(.+)'){
          $key = $Matches[1].Trim(); $Value = $Matches[2].Trim()

          if($Temp_YN -match 'Y' -and $Value -ne 0){
            write-host $key".    " -NoNewline -ForegroundColor Green
            $l++
          }
          elseif($Value -eq 0) {
            write-host $key".    " -NoNewline -ForegroundColor Red
            $l++
          }
        }
      }

       while(1){
        Write-Host ""; write-host "Have you donated a new item? (Y/N): " -nonewline
        $Temp_YN = read-host; $Line = 0
        if ($Temp_YN -match 'Y'){
            write-host "Write the name of what you have donated (or just 'copy paste' it): " -NoNewline; $Choice_1 = Read-Host
  
            foreach($SpecItem in $RawList[$CAT_lineNum[$i - 1]..($CAT_lineNum[$i])]){
                if ($Choice_1 -eq ""){break}
                elseif($SpecItem -match $Choice_1){
                   if($SpecItem -match '(.+)=1'){
                     Write-Host "The item is already marked `"donated`"!"
                   }
                   else{
                     $CurrentLine = $Line + $CAT_lineNum[$i - 1]
                     $RawList[$CurrentLine] = ($Choice_1.Substring(0, 1).ToUpper() + $Choice_1.Substring(1).ToLower()) + "=1"
                     $RawList | Set-Content $list
                     write-host "Done!"
                   }
                break
                }
                elseif ($line + 1 -eq $CAT_lineNum[$i] - $CAT_lineNum[$i - 1]){ Write-Host "Item name written incorrectly."; break}
                $Line++
            }
          }
          else{
              break
          }
      }
    }
    elseif( $i -Match '99'){ # Reset the list
      Write-Host "Are you sure you want to RESET your list? For yes, write (Yes, Reset the list); anything else means no: " -NoNewline
      $i = Read-Host
      if ( $i -match 'Yes, Reset the list'){
        $CurrentLine = 0
        foreach ($line in $RawList){
          if ($line -match '(.+)=1'){
          $RawList[$CurrentLine] = $Matches.1 + "=0"
          $RawList | Set-Content $list
          }
          $CurrentLine++
        }
      } # After finishing
      if ( $i -match 'Yes, Reset the list'){
        Write-Host "The list have been reseted: " -NoNewline -ForegroundColor DarkRed; $i = Read-Host
      }
      else {
        Write-Host "The list haven't been reseted: " -NoNewline -ForegroundColor Green; $i = Read-Host
      }
    }
    else{ # Loop Breaker
        write-host "Quit ? (Y/N)"
        $i = read-host
        if ($i -match 'Y'){
            return
        }
    }
    Write-Host ""
   }
}
else{
    Write-Host "Error: The `"Collectable(s)List.txt`" haven't been found in the SCRIPT directory."
}