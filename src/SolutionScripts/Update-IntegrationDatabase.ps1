Function global:Update-IntegrationDatabase()
{
    $migrationsProject = $integrationDatabase.migrationsProject
    $appConfigProject = $integrationDatabase.appConfigProject
    $connectionStringName = $integrationDatabase.connectionStringName
    $migrationHistoryTableName = "__MigrationHistory"

    # get the directory of this script file
    $solutionDirectory = $solutionPaths.src

    # get the full path and file name of the App.config file in the same directory as this script
    $appConfigFile = [IO.Path]::Combine($solutionDirectory, $appConfigProject + '\App.config')

    Write-Host "Using connection string '$connectionStringName' from [$appConfigFile]"
    $connectionStringElement = Load-ConnectionString "$connectionStringName" "$appConfigProject\App.config"
    $cs = $connectionStringElement.connectionString
    $connectionStringTokens = ParseConnectionString $cs

    $serverName = $connectionStringTokens.serverName
    $databaseName = $connectionStringTokens.databaseName
    $databaseLogin = $connectionStringTokens.databaseLogin
    $databasePassword = $connectionStringTokens.databasePassword

    $server = Get-Server $serverName $databaseLogin $databasePassword

    if (($server.Databases.Contains($databaseName)))
    {
        #If the database does exist, make sure it has had the base migration applied
        if (!($server.Databases[$databaseName].Tables.Contains($migrationHistoryTableName)))
        {
            $projectDirectory = Get-ProjectDirectory $migrationsProject
            Write-Host "Using project directory at $projectDirectory"
            $migrationScriptDirectory = Join-Path -Path $projectDirectory -ChildPath "\PreMigrations"
            Write-Host "Applying scripts from $migrationScriptDirectory"
            $sqlFiles = [IO.Directory]::GetFiles($migrationScriptDirectory, "*.sql")
            [array]::sort($sqlFiles)
            foreach($sqlFile in $sqlFiles)
            {
                $pathSplits = $sqlFile.Split('\')
                $fileName = $pathSplits[$pathSplits.Length - 1]
                Write-Host "... $($fileName)"
                $sr = New-Object System.IO.StreamReader($sqlFile)
                $script = $sr.ReadToEnd()
                $server.Databases[$databaseName].ExecuteNonQuery($script)
            }
            Write-Host "All scripts applied."
        }
    }

    Write-Host "Updating database with following parameters"
    Write-Host "    Migrations Project: $($migrationsProject)"
    Write-Host "    Config Project:     $($appConfigProject)"
    Write-Host "    Connection String:  $($connectionStringName)"

    Write-Host "Migrating database"
    Update-Database -ProjectName $migrationsProject -StartUpProjectName $appConfigProject -ConnectionStringName $connectionStringName
    Write-Host "Database migrated." -ForegroundColor DarkGreen
}