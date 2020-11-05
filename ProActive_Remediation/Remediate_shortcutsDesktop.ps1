$ErrorActionPreference = "silentcontinue"
$results =@()
$OneDrive =@()

# Define Variables
$Lang = (Get-WinSystemLocale).LCID

if($Lang -ne "1034") {
    #United States (EN-US)
    $PP = "$env:SystemDrive\Users\"
    $PPU = (get-childitem -path $PP | Where-Object {($_.Name -notlike "default*")} | Where-Object  {($_.Name -ne "public")}).FullName
        foreach ($OneDrive in $PPU) {
            #Find $OneDrive
            $OneDriveLocations = (get-childitem -path $PPU -Filter "OneDrive*" -ErrorAction SilentlyContinue).FullName
         }
} elseif ($Lang -eq "1034") {
    #Dutch (NL-NL)
    $PP = "$env:SystemDrive\Gebruikers\"
    $PPU = (get-childitem -path $PP | Where-Object {($_.Name -notlike "default*")} | Where-Object  {($_.Name -ne "publiek")}).FullName
        foreach ($OneDrive in $PPU) {
            #Find $OneDrive
            $OneDriveLocations =  (get-childitem -path $PPU -Filter "OneDrive*" -ErrorAction SilentlyContinue).FullName
         }
    
}
try
{
    foreach($OneDriveLocation in $OneDriveLocations) {

        $results = get-childitem -Path $OneDriveLocation  -Filter "Microsoft Edge*.lnk" -Recurse -ErrorAction SilentlyContinue
        $results += get-childitem -Path $OneDriveLocation -Filter "Microsoft Teams*.lnk" -Recurse -ErrorAction SilentlyContinue
    }

   foreach ($Item in $results) {
        remove-item $Item.FullName -Force 
    }
} catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}
exit 0