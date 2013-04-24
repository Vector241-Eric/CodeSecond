[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
# Assemblies needed for database backup operation
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null


Function Get-Server([string]$sql_server, [string]$user = $null, [System.Security.SecureString]$pass = $null)
{
    if ($user) {
        Write-Host "Connecting to SQL Server using standard security for user '$user'..."

        $server = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $sql_server
        $server.ConnectionContext.LoginSecure = $false
        $server.ConnectionContext.Login = $user
        $server.ConnectionContext.SecurePassword = $pass
    } else {
        # Initialize Server instance using integrated security
        Write-Host "Connecting to SQL Server using integrated security..."

        $server = new-object ('Microsoft.SqlServer.Management.Smo.Server') $sql_server
    }
    
    # Don't let operations performed on this Server time out
    $server.ConnectionContext.StatementTimeout = 0
    
    $server
}

Function Restore-Database32 ([string]$sqlServer, [string]$databaseName, [string] $user = $null, [System.Security.SecureString] $pass = $null, [string] $backupFile, [Hashtable] $usersToReassociate, [string] $dataPath = $null, [string] $logPath = $null) {
    trap [Exception] { 
        write-error $("ERROR: " + $_.Exception.ToString()); 
        break; 
    }
    $server = Get-Server $sqlServer $user $pass
    $smoRestore = New-Object("Microsoft.SqlServer.Management.Smo.Restore")

    # Add the bak file as a device
    $backupDevice = New-Object("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($backupFile, "File")
    $smoRestore.Devices.Add($backupDevice)
        
    # Determine default DATA path for this server instance
    # NOTE:  Using Invoke-Command to read from the 64-bit registry (if on 64-bit OS) -- regardless of
    #        whether this code is running in a 32-bit or 64-bit shell
    $instanceName = Invoke-Command -ComputerName localhost -ScriptBlock {gi "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" | %{$_.GetValue("MSSQLSERVER")}}

    # Check registry for data path, if not provided
    if ($dataPath -eq $null -or $dataPath -eq "") {
        # FYI: $backupPath = gi "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceName\MSSQLServer" | %{$_.GetValue("BackupDirectory")}
        # NOTE:  Using Invoke-Command to read from the 64-bit registry (if on 64-bit OS) -- regardless of
        #        whether this code is running in a 32-bit or 64-bit shell
        $dataPath = Invoke-Command -ComputerName localhost -ScriptBlock {gi "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceName\MSSQLServer" | %{$_.GetValue("DefaultData")}}
    }
        
    # Check registry for log path, if not provided
    if ($logPath -eq $null -or $logPath -eq "") {
        # NOTE:  Using Invoke-Command to read from the 64-bit registry (if on 64-bit OS) -- regardless of
        #        whether this code is running in a 32-bit or 64-bit shell
        $logPath = Invoke-Command -ComputerName localhost -ScriptBlock {gi "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceName\MSSQLServer" | %{$_.GetValue("DefaultLog")}}
    }
        
    $setupRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceName\Setup"
    # Resort to setup paths if new defaults have not been specified.
    if ($dataPath -eq $null -or $dataPath -eq "") {
        # NOTE:  Using Invoke-Command to read from the 64-bit registry (if on 64-bit OS) -- regardless of
        #        whether this code is running in a 32-bit or 64-bit shell
        $dataPath = Invoke-Command -ComputerName localhost -ScriptBlock {param($path) gi $path | %{$_.GetValue("SQLDataRoot")}} -ArgumentList $setupRegistryKeyPath
    }

    if ($logPath -eq $null -or $logPath -eq "") {
        # NOTE:  Using Invoke-Command to read from the 64-bit registry (if on 64-bit OS) -- regardless of
        #        whether this code is running in a 32-bit or 64-bit shell
        $logPath = Invoke-Command -ComputerName localhost -ScriptBlock {param($path) gi $path | %{$_.GetValue("SQLDataRoot")}} -ArgumentList $setupRegistryKeyPath
    }
        
    #Write-Host "DEBUG: instanceName = $instanceName"
    #Write-Host "DEBUG: dataPath = $dataPath"
        
    # Relocate the files
    $mdfFilePath = $smoRestore.ReadFileList($server).Rows[0][1]
    $dataFile = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
    $dataFile.LogicalFileName = $smoRestore.ReadFileList($server).Rows[0][0]
    $dataFile.PhysicalFileName = [IO.Path]::Combine($dataPath, $databaseName + [IO.Path]::GetExtension($mdfFilePath))
    #$dataFile.PhysicalFileName = [IO.Path]::Combine([IO.Path]::GetDirectoryName($mdfFilePath), $databaseName + [IO.Path]::GetExtension($mdfFilePath))

    $ldfFilePath = $smoRestore.ReadFileList($server).Rows[1][1]
    $logFile = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
    $logFile.LogicalFileName = $smoRestore.ReadFileList($server).Rows[1][0]
    $logFile.PhysicalFileName = [IO.Path]::Combine($logPath, $databaseName + [IO.Path]::GetExtension($ldfFilePath))
    #$logFile.PhysicalFileName = [IO.Path]::Combine([IO.Path]::GetDirectoryName($ldfFilePath), $databaseName + [IO.Path]::GetExtension($ldfFilePath))
        
    $smoRestore.RelocateFiles.Add($dataFile) | out-null
    $smoRestore.RelocateFiles.Add($logFile) | out-null
        
    # Set options
    $smoRestore.Database = $databaseName
    $smoRestore.NoRecovery = $false
    $smoRestore.ReplaceDatabase = $true
    $smoRestore.Action = "Database"
        
    $backupSets = $smoRestore.ReadBackupHeader($server)
    $smoRestore.FileNumber = $backupSets.Rows.Count # Most recent backup in the set

    # Write-Host "DEBUG: backup sets in file: $($smoRestore.FileNumber)"
        
    # Show notifications
    $smoRestore.PercentCompleteNotification = 10
        
    #$smoRestoreDetails = $smoRestore.ReadBackupHeader($server)
    #"Database Name from Backup Header : " + $smoRestoreDetails.Rows[0]["DatabaseName"]
        
    # Forcibly close all connections on the target database
    $server.KillAllProcesses($databaseName)
        
    #create server users for db users to be re-assoicated
    if ($usersToReassociate -ne $null) {
        foreach ($user in $usersToReassociate.Keys) {  
            Initialize-SqlLogin $null "$user" $usersToReassociate["$user"] -serverInstance $server
        }
    }
    # Restore the database
    # Trap { Write-Host -Fore Red -back White $_.Exception.ToString(); Break; };        
    $smoRestore.SqlRestore($server)
        
    # Reassociate user accounts with logins on server
    # (Useful in scenarios where database is being restored on a different server)
    if ($usersToReassociate -ne $null) {
        $db = $server.Databases[$databaseName]
            
        foreach ($user in $usersToReassociate.Keys) { 
            Write-Host "Reassociating user account '$user' ..."
            $query = "IF EXISTS (SELECT name FROM sys.database_principals WHERE name = `'$user`')"
            $query += "BEGIN `nALTER USER $user with LOGIN=$user `nEND"
            $db.ExecuteNonQuery($query)
        }
    }   
}

Export-ModuleMember Restore-Database32
