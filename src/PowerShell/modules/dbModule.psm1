[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
# Assemblies needed for database backup operation
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

Function Get-SqlConnectionString ([string] $serverName, [string] $databaseName, [Net.NetworkCredential] $creds)
{
    if (($creds -eq $null) -or ($creds.UserName -eq "")) {
        "Server=$serverName;Database=$databaseName;Trusted_Connection=True;"
    } else {
        "Server=$serverName;Database=$databaseName;User ID=$($creds.UserName);Password=$($creds.Password);"
    }
}

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

Function Invoke-SqlScript ([string]$connectionString, [string]$sql, [Int32]$commandTimeout = 30)
{
    # Strip out all block comments
    $sql_no_comments = $sql -replace "(?s)/\*.*?\*/", ""
    
    # Parse out the individual commands within the script
    $sql_no_go = $sql_no_comments -replace "(?m)^\s*GO\s*$", "~"
    $sql_commands = $sql_no_go.Split([char[]]@("~"))
    
    ## Connect to the data source and open it
    $connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
    $connection.Open()
    
    try {
        $command = New-Object System.Data.SqlClient.SqlCommand
        $command.Connection = $connection
        $command.CommandTimeout = $commandTimeout
        foreach ($sql_command in $sql_commands) {
            # Skip empty commands
            if ([System.String]::IsNullOrEmpty($sql_command)) {
                continue
            }
            
            # Execute sql command
            $command.CommandText = $sql_command
            $result = $command.ExecuteNonQuery()
            
            # Capture and report errors
            trap [Exception]
            {
                Write-Host $_.Exception.Message -ForegroundColor Red
                Write-Host "Failing command: " $sql_command
                Write-Host "Last successful command:" $last_successful_command
                throw
            }
            
            # Make note of last successful command, to aid in troubleshooting the problem
            $last_successful_command = $sql_command
        }
    } finally {    
        # Clean up our objects
        if ($command -ne $null) {
            $command.Dispose()
        }
            
        $connection.Close()
    }
}

Function Test-DatabaseExists([Microsoft.SqlServer.Management.Smo.Server]$server, $databaseName) {
    $found = $false
    #Makesure we have the latest database information.
    $server.Databases.Refresh($true)
    foreach ($db in $server.Databases) {
        if ($db.Name -eq $databaseName) {
            $found = $true
            break
        }
    }
    
    $found
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

# Will delete the database if it exists
Function Remove-Database ([string]$sql_server, [string]$database_name, [string] $username = $null, [System.Security.SecureString] $password = $null, [switch]$safe)
{
    try {
        $s = Get-Server $sql_server $username $password
        if (Test-DatabaseExists $s $database_name) {
            if ($password -eq $null) {
                $netCreds = new-object Net.NetworkCredential($username, $null)
            }
            else {
                $netCreds = new-object Net.NetworkCredential($username, ([System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($password))))
            }
            $connectionString = Get-SqlConnectionString $sql_server "master" $netCreds
            #Try to kill db connections ahead of time.
            $killUsersSQL = @"
                            -- Create the sql to kill the active database connections 
                            declare @execSql varchar(1000), @databaseName varchar(100) 
                            -- Set the database name for which to kill the connections 
                            set @databaseName = '$($database_name)' 
                            set @execSql = '' 
                            select @execSql = @execSql + 'kill ' + convert(varchar(10), spid) + ' ' 
                           from master..sysprocesses 
                           where db_name(dbid) = '$database_name'
                            and DBID <> 0 
                            and spid <> @@spid 
                            and status <> 'background' 
                            -- to get the user process
                            and status in ('runnable','sleeping') 
                            exec (@execSql) 
                            GO
"@
            Invoke-SqlScript $connectionString $killUsersSQL
            if ($safe) {
                #$db = $s.Databases.Item("$database_name")
                #Try to make sure there is nothing pending. This didn't work.
                #$s.KillAllProcesses("$database_name") $db.SetOffline(); $db.SetOnline();
                #This is very fast if nothing is pending, otherwise it will cause a wait, but prevent an error.
                $this = Resolve-Path "$($folders.modules.invoke('\database\database-management.psm1'))"
                $scriptCommand = {$vars = $null
                $Input.'<>4__this'.read() | %{$vars = $_};
                foreach ($var in $vars.Keys) {if ("$var" -ne ""){Set-Variable $var -Value $($vars[$var]) -Scope Script -Force}};
                Import-Module $this;
                $s = Get-Server $sql_server $username $password;
                $db = $s.Databases.Item("$database_name");
                $db.SetOffline();
                $db.SetOnline();}
                Start-Job -Name "DB_Stop_$database_name" $scriptCommand -InputObject @{sql_server = $sql_server; username = $username; password = $password; database_name = $database_name; this = $this}
                $timeout = 0
                do{
                    $job = Get-Job -Name "DB_Stop_$database_name" | where { $_.State -ne "Completed"}
                    if ($job) {
                        if($job.State -eq "Failed") { throw "Stopping $database_name failed!"; break}
                        if($timeout % 10 -eq 0) { Write-Host "Status: $($job.State)" }
                        Sleep 1
                        $timeout++
                    }
                    else { break }
                }while ($timeout -lt 600)
                if ($timeout -ge 599) {
                    throw "Failed to stop $database_name after 10 min. Please check if there are any active connection to the database."
                }
                else {
                    #Clear Log
                    receive-job -Name "DB_Stop_$database_name"
                }
            }
            $s.KillDatabase($database_name)
            Write-Host "Removed database $database_name"
        } else {
            Write-Host "$database_name does not yet exist."
        }
    }
    catch {
        Write-Host "Attempt to remove database $database_name failed: `n`t$_`n" -ForegroundColor Red
    }
}


Export-ModuleMember Restore-Database32, Remove-Database, Get-Server
