Function global:Reset-IntegrationDatabaseWithoutMigrations([string]$dbBackupName)
{
	Function Restore-IntegrationDatabase([string]$databaseName, [string]$sqlServerName, [string]$dbBackupName)
	{
		$msSqlBackupPath = $solutionPaths.tempBackupPath

		$useDefaultDatabase = (-not $dbBackupName)
		if ($useDefaultDatabase){
			Ensure-PathExists $msSqlBackupPath
			$dbBackupName = (Get-ChildItem -Path $msSqlBackupPath -Filter "*.bak" | Sort-Object name -Descending | Select-Object -First 1).Name
		}

		if (-not $dbBackupName -or -not (Test-Path "$msSqlBackupPath\$dbBackupName")) {
			throw "Cannot find file $dbBackupName or $msSqlBackupPath\$dbBackupName"
		}

		$backupFile = $dbBackupName
		if ((-not (Test-Path $backupFile)) -and (Test-Path "$msSqlBackupPath\$dbBackupName")) {
			$backupFile = Join-Path -ChildPath $dbBackupName -Path $msSqlBackupPath
		}

		#Restore
		Write-Host "Restoring from backup at $backupFile"
		Write-Host "Database will be restored with name '$databaseName' on '$sqlServerName'"
		Restore-Database32 $sqlServerName $databaseName -backupFile "$backupFile"
		Write-Host "Database restored." -ForegroundColor DarkGreen
	}

    $Error = ''

    $appConfigPath = "$($integrationDatabase.appConfigProject)\App.config"
    $connectionStringName = $integrationDatabase.connectionStringName

    $connectionStringElement = Load-ConnectionString $connectionStringName $appConfigPath
    $connectionString = $connectionStringElement.connectionString
    $connectionStringTokens = ParseConnectionString $connectionString

    $databaseName = $connectionStringTokens.databaseName
    $sqlServerName = $connectionStringTokens.serverName

    Restore-IntegrationDatabase $databaseName $sqlServerName $dbBackupName
             
    DumpErrors;
}

Function global:Reset-IntegrationDatabase([string]$dbBackupName)
{
	Reset-IntegrationDatabaseWithoutMigrations $dbBackupName

    #Migrate the database (including applying the pre-migrations)
    Update-IntegrationDatabase
	
}