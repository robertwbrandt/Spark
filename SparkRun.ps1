#     Script to start the OPW version of Spark
#     Bob Brandt <projects@brandt.ie>
#          
#     Copyright (C) 2013 Free Software Foundation, Inc."
#     License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#     This program is free software: you can redistribute it and/or modify it under
#     the terms of the GNU General Public License as published by the Free Software
#     Foundation, either version 3 of the License, or (at your option) any later
#     version.
#     This program is distributed in the hope that it will be useful, but WITHOUT ANY
#     WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#     PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#

# This function is used to either Replace or Add configuration values to the Spark 
# configuration files
function ReplaceOrAdd ($text, $file)
{
    $pos = $text.IndexOf("=")
    $search = "^" + $text.Substring(0, $pos + 1) + ".*"
    if ( Get-ChildItem "$file" | Select-String -Pattern "$search" ) {
    ( Get-Content "$file" ) -replace "$search", "$text" | Set-Content -Encoding ASCII "$file"
    } else { "$text" | Out-File -Append -Encoding ASCII -FilePath "$file" }
}

# Check to see if the user have logged into the I domain (i.opw.ie)
if ( ${env:USERDOMAIN} -eq "i" ) {
    # We only want one instance of Spark running at a time.
    Stop-Process -name "spark" -Force

    # Find the spark configuration file for this user.
    $file = "${env:APPDATA}\Spark\spark.properties"
    # Replace/Add specific properties.
    ReplaceOrAdd -text "username=${env:USERNAME}" -file "$file"
    ReplaceOrAdd -text "xmppHost=im.opw.ie" -file "$file"
    ReplaceOrAdd -text "autoLoginEnabled=true" -file "$file"
    ReplaceOrAdd -text "sslEnabled=false" -file "$file"
    ReplaceOrAdd -text "useHostnameAsResource=true" -file "$file"
    ReplaceOrAdd -text "showAvatar=true" -file "$file"
    ReplaceOrAdd -text "useSingleTrayClick=true" -file "$file"
    ReplaceOrAdd -text "startHidden=true" -file "$file"
    #ReplaceOrAdd -text "proxyEnabled=true" -file "$file"
    #ReplaceOrAdd -text "host=webproxy.i.opw.ie" -file "$file"
    #ReplaceOrAdd -text "port=8080" -file "$file"
    #ReplaceOrAdd -text "ssoEnabled=true" -file "$file"
    #ReplaceOrAdd -text "ssoMethod=dns" -file "$file"
    
    # Start the Spark program
    Start-Process -FilePath "${env:ProgramFiles(x86)}\Spark\Spark.exe" -WorkingDirectory "${env:ProgramFiles(x86)}\Spark"
    
} else { "Not in the I domain" }
