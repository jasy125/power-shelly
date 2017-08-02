
# ---------------------------------------------------------------
#
# Script to copy all user files to new location with Permissions
#
# This was designed to copy users Home folders from one location to a new location on a DFS setup.
# If you do not require a general file location set both newPath and homePath to the same value
#
# ---------------------------------------------------------------

#Import the AD module
import-module ActiveDirectory

#Variables to be changed

$newPath = "Newpath" #NewPath
$homePath = "HomePath" #HomePath set to same as above if you are not using any DFS like appliance 
$domainExt = "@domain.com"
$excludeUsers = @("users","to","exclude","from","move") #exclude these users
$ou = "OU=Path,OU=in,OU=OU,DC=domain,DC=com" #update to your ou

#Get list of all users from  OU - turn this into a switch statement for all ou's

$siteUsers = Get-ADUser -Filter * -SearchBase $ou | Sort-Object;

    foreach ($user in $siteUsers) {
       $userName = $user.UserPrincipalName.Replace($domainExt,"");

        if($excludeUsers.Contains($userName)) {
            write-Output "Do not include $userName";

          } else {
                
                  #Lets move this users home folder and update the ad path
                   $currentPath = Get-ADUser $username -Properties HomeDirectory | Select HomeDirectory 
                   $currentPath = $currentPath.HomeDirectory; #Current location of the homedirectory on the users account
                   $homeDir = $homePath +  $currentPath.split("\")[-1];#Path that the ad homedirectory should be updated too
                   $newPath = $newPath + $currentPath.split("\")[-1]; #Path to where robocopy will copy the files too

                    #copy our folders from current to new path with Robocopy
                       #robocopy $currentPath $newPath *.* /mir /sec

                       #once complete update users ad attribute 
                         #Set-AdUser $currentUser -HomeDirectory $homeDir
              }
     }

