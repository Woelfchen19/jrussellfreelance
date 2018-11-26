﻿# This script stops the nginx and php-fpm services on the specified server
param($server,
$username,
$password
)
# Create credential object based on parameters
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
# Create SSH session
$session = New-SSHSession -ComputerName $server -Credential $creds
# Convert entered password to secure string
$secPass = ConvertTo-SecureString $creds.Password -AsPlainText -Force
# Start Shell Stream
$stream = $session.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
# Stop nginx and php-fpm
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo systemctl stop php7.0-fpm"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo systemctl stop nginx"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
Remove-SSHSession -SessionId 0
# Finished