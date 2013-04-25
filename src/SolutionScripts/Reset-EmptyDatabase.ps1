Function global:Reset-EmptyDatabase()
{
    $appConfigPath = "$($emptyDatabase.appConfigProject)\App.config"
    $connectionStringName = $emptyDatabase.connectionStringName
    $connectionString = Load-ConnectionString $connectionStringName $appConfigPath

    $connectionStringTokens = ParseConnectionString $connectionString.connectionString
    Write-Host "Removing test database $($connectionStringTokens.databaseName) on $($connectionStringTokens.serverName)"
    Remove-Database $connectionStringTokens.serverName $connectionStringTokens.databaseName
    Write-Host "Database removed." -ForegroundColor DarkGreen

    #Migrate the database (including applying the pre-migrations)
    Update-EmptyDatabase
}